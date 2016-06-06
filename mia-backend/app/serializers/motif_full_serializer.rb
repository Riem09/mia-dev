class MotifFullSerializer < MotifSerializer

  has_many :children
  has_many :ancestors

end
