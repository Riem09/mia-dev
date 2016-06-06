class RelatedMotifSerializer < ActiveModel::Serializer
  attributes :id
  belongs_to :motif1
  belongs_to :motif2
end
