class VideoUploadSerializer < ActiveModel::Serializer

  attributes :id, :webm_video_url, :mp4_video_url, :status, :message, :created_at, :duration_ms

  belongs_to :user, :serializer => UserSerializer

end
