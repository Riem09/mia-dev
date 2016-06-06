class VideoSerializer < ActiveModel::Serializer

  attributes :id, :title, :description, :published, :created_at, :updated_at, :duration_ms

  attributes :combined_start_time, :combined_end_time

  belongs_to :video_upload, :serializer => VideoUploadSerializer
  has_many :video_motifs, :serializer => VideoMotifSerializer
  has_many :motifs_with_icon

end
