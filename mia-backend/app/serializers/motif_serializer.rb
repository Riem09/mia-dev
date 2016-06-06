class MotifSerializer < ActiveModel::Serializer
  
  attributes :id, :name, :description, :created_at, :updated_at, :image_url, :icon_url, :hex_color

  has_many :related_motifs
  has_many :video_motifs

  belongs_to :parent
  belongs_to :owner
  belongs_to :video_upload

  def ancestors
    object.path
  end

end
