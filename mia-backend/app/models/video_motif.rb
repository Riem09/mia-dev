class VideoMotif < ActiveRecord::Base
  belongs_to :video, :touch => true
  belongs_to :motif
  belongs_to :owner, :class_name => "User"

  validates_presence_of :video, :motif, :owner

  validate :start_and_end_times

  def start_and_end_times
    unless start_time_ms
      self.start_time_ms = 0
    end
    unless end_time_ms
      self.end_time_ms = video.duration_ms
    end
  end

  scope :general,     -> { joins(:video).where("start_time_ms = 0 AND end_time_ms = videos.duration_ms" ) }
  scope :timestamped, -> { joins(:video).where("(start_time_ms >= 0 AND end_time_ms < videos.duration_ms) OR (start_time_ms > 0 AND end_time_ms <= videos.duration_ms)" ) }

  scope :with_ancestor_id, ->(motif_id) {
    joins('INNER JOIN motif_ancestors ON motif_ancestors.motif_id = video_motifs.motif_id').where(:'motif_ancestors.ancestor_id' => motif_id)
  }

end
