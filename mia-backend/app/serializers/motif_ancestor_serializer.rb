class MotifAncestorSerializer < ActiveModel::Serializer
  attributes :id

  belongs_to :ancestor
  belongs_to :motif
end
