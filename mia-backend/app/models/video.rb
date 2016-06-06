require 'uri'
require 'google/api_client'
require 'vimeo'

class Video < ActiveRecord::Base

  attr_accessor :duplicate_video

  self.per_page = 16

  YOUTUBE_API_SERVICE_NAME = 'youtube'
  YOUTUBE_API_VERSION = 'v3'

  belongs_to :owner, :class_name => 'User'
  belongs_to :video_upload, :inverse_of => :video, :dependent => :destroy

  has_many :video_motifs, :dependent => :destroy
  has_many :motifs, :through => :video_motifs
  has_many :motifs_with_icon, -> () { where.not(:icon => nil) }, :through => :video_motifs, :source => :motif

  accepts_nested_attributes_for :video_upload, :reject_if => proc { |a| a['source_video'].blank? }

  validate :is_valid_external_url, if: proc { |v| v.external_url.present? }
  validate :is_video_upload, if: proc { |v| v.external_url.blank? }
  validate :video_is_not_a_duplicate
  validate :thumbnails_exist, if: proc { |v| v.external_url.present? }
  validates :owner, presence: true
  validates :title, presence: true, if: proc { |v| v.type == "UploadedVideo" }
  validates :published, inclusion: { in: [true, false] }

  validate do
    errors.add(:motifs, "Video must have at least 5 general motifs") if video_motifs.general.count < 5 && published?
    errors.add(:motifs, "Video must have at least 5 timestamped motifs") if video_motifs.timestamped.count < 5 && published?
  end

  scope :motifs_include, -> (motif_id) {
    joins(:video_motifs => { :motif => :motif_ancestors })
      .where('video_motifs.motif_id = ? OR motif_ancestors.ancestor_id = ?', motif_id, motif_id)
      .group(:video_id)
  }

  scope :motifs_include_all, -> (motif_ids) {
    motif_ids.map { |mid|
      #find video motifs whose ancestor includes a motif_id
      joins(:video_motifs).merge(VideoMotif.with_ancestor_id(mid))#.select(:'videos.id')
    }.reduce(self) do |sc, subquery|
      #now find all videos whose video motifs are among the above
      sc.where(:id => subquery.pluck(:id) )
    end
  }

  scope :has_combined_motifs, -> (motif_ids) {
    query = select("videos.*")
    if motif_ids.any?
      query = query.select("#{(0..(motif_ids.length-1)).map { |i| "vm#{i}.id AS vm#{i}" }.join(', ')}, '#{motif_ids.length}' AS vm_count")
    end
    motif_ids.each_with_index { |id, index|
      query = query.joins("INNER JOIN video_motifs AS vm#{index} ON (videos.id = vm#{index}.video_id)")
      query = query.where("vm#{index}.motif_id = ?", id)
      #compare with the previous queries to get all permutations
      index.times do |i|
        query = query.where("vm#{index}.start_time_ms <= vm#{i}.end_time_ms AND (vm#{index}.end_time_ms IS NULL OR vm#{index}.end_time_ms >= vm#{i}.start_time_ms)")
      end
    }
    query
  }

  def published?
    self.published == true
  end

  def get_combined_motif_vm_ids
    vm_ids = []
    if respond_to? :vm_count
      vm_count.to_i.times do |i|
        vm_ids << send("vm#{i}".to_sym)
      end
    end
    vm_ids
  end

  #only used if 'has_combined_motifs' was called
  def combined_start_time
    video_motifs.where(:id => get_combined_motif_vm_ids).maximum(:start_time_ms)
  end

  #only used if 'has_combined_motifs' was called
  def combined_end_time
    video_motifs.where(:id => get_combined_motif_vm_ids).minimum(:end_time_ms)
  end

  scope :keywords_include, -> (keywords) {
    keywords.reduce(self) do |sc, keyword|
      sc.where("videos.title LIKE :keyword OR videos.description LIKE :keyword", { :keyword => "%#{keyword}%" })
    end
  }

  def thumbnails_exist
    if self.title.blank? || self.thumbnail_default.blank? || self.thumbnail_medium.blank? || self.thumbnail_high.blank?
      update_external_video_details
    end
  end

  def is_valid_external_url
    if Video.vimeo_url?(self.external_url)
      self.external_id = Video.parse_vimeo_external_id(self.external_url)
      if !self.external_id
        errors.add(:external_url, "is not a valid Vimeo URL")
      end
      self.type = VimeoVideo
    elsif Video.youtube_url?(self.external_url)
      self.external_id = Video.parse_youtube_external_id(self.external_url)
      if !self.external_id
        errors.add(:external_url, 'is not a valid YouTube URL')
      end
      self.type = YouTubeVideo
    else
      errors.add(:external_url, 'is not a valid video URL')
    end
  end

  def is_video_upload
    if video_upload.blank?
      errors.add(:video_upload, "must be provided.")
    else
      self.type = UploadedVideo
    end
  end

  def duration_ms
    if self.video_upload
      video_upload.duration_ms
    else
      read_attribute(:duration_ms)
    end
  end

  def video_is_not_a_duplicate
    duplicate = Video.where.not(:external_id => nil).where(:external_id => external_id, :type => type).where.not(:id => id).first
    if duplicate
      errors.add(:duplicate, "is a duplicate video.")
      self.duplicate_video = duplicate
    end
  end

  def self.vimeo_url?(url)
    !/^(?:https?:\/\/)?(?:www\.)?vimeo\.com/.match(url).nil?
  end

  def self.youtube_url?(url)
    !/(?:https?:\/\/)?youtu(\.be)|(be\.com)/.match(url).nil?
  end

  def self.parse_vimeo_external_id(url)
    match_data = /https?:\/\/(?:www\.)?vimeo\.com(?:\/[^\/]*)*(?:\/(\d+))$/.match( url )
    if match_data
      match_data[1]
    else
      nil
    end
  end

  def self.parse_youtube_external_id(url)
    match_data = /.*(?:youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=)([^#\&\?]*).*$/.match(url)
    if match_data
      match_data[1]
    else
      nil
    end
  end

  def self.retrieve_youtube_data(video_id)
    client = Google::APIClient.new(
        :application_name => 'MIA Video Researcher',
        :application_version => '0.1'
    )
    client.key = Rails.configuration.google_api_key
    client.authorization = nil
    youtube = client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)

    video_list_response = client.execute!(:api_method => youtube.videos.list, :parameters => {
      :id => video_id,
      :part => 'snippet,contentDetails'
    })

    response = {}

    video_list_response.data.items.each do |item|
      snippet = item['snippet']
      response[:title] = snippet['title']
      response[:description] = snippet['description']
      response[:thumbnail_default] = snippet['thumbnails']['default']['url']
      response[:thumbnail_medium] = snippet['thumbnails']['medium']['url']
      response[:thumbnail_high] = snippet['thumbnails']['high']['url']
      contentDetails = item['contentDetails']
      response[:duration_ms] = parseDuration( contentDetails['duration'] )
    end

    response
  end

  def self.parseDuration(contentDetailsDuration)
    md = /PT((\d+)M)?(\d+)S/.match(contentDetailsDuration)
    result = 0
    if md
      if (md.length > 2)
        result += md[1].to_i * 60 + md[3].to_i
      else
        result += md[1].to_i
      end
    end
    result
  end

  def self.retrieve_vimeo_data(video_id)

    data = Vimeo::Simple::Video.info(video_id)

    response = {}

    video = data.first

    response[:title] = video['title']
    response[:description] = video['description']
    response[:thumbnail_default] = video['thumbnail_small']
    response[:thumbnail_medium] = video['thumbnail_medium']
    response[:thumbnail_high] = video['thumbnail_large']
    response[:duration_ms] = video['duration']

    response

  end

  def update_external_video_details
    if self.type == 'VimeoVideo'
      assign_attributes(Video.retrieve_vimeo_data(self.external_id))
    elsif self.type == 'YouTubeVideo'
      assign_attributes(Video.retrieve_youtube_data(self.external_id))
    end
  end

end
