class MotifSerializer < ActiveModel::Serializer
  attributes :id, :name

  has_many :children
  has_many :related_motifs
  has_many :motif_ancestors

  belongs_to :parent
  belongs_to :owner
  belongs_to :video_upload

end
