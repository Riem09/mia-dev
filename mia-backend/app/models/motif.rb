require 'digest/md5'

class Motif < ActiveRecord::Base

  MOTIF_COLOURS = [
      '#f68988',
      '#ffb3e9',
      '#b8a4e9',
      '#b36595',
      '#99eaff',
      '#58d68d'
  ]

  has_ancestry

  mount_uploader :image, ImageUploader
  mount_uploader :icon, ImageUploader

  belongs_to :video_upload, :dependent => :destroy
  belongs_to :owner, :class_name => "User"

  accepts_nested_attributes_for :video_upload, :reject_if => proc { |a| a['source_video'].blank? }

  validates :owner, presence: true
  validates :name, presence: true
  
  has_many :related_motifs, :foreign_key => 'motif1_id'
  has_many :video_motifs, :dependent => :destroy
  has_many :videos, -> { uniq }, :through => :video_motifs

  def hex_color
    if self.parent.nil?
      if self.id.nil?
        "#000000"
      else
        MOTIF_COLOURS[ self.id % MOTIF_COLOURS.length ]
      end
    else
      self.parent.hex_color
    end
  end

  def self.with_name_like(name)
    motifs = Motif.arel_table
    query = "%#{name}%"
    where( motifs[:name].matches(query) )
  end

  def image_url
    image ? image.url : parent.try(:image_url)
  end

  def icon_url
    icon.try(:url)
  end

end
