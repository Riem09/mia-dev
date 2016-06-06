class VideoMotifSerializer < ActiveModel::Serializer

  attributes :id, :description, :start_time_ms, :end_time_ms, :created_at, :updated_at

  belongs_to :video
  belongs_to :motif
  belongs_to :owner
end
