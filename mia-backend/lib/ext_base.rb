class Object

  def boolean?
    self.is_a?(TrueClass) || self.is_a?(FalseClass)
  end

end

class String

  TRUE_VALUES = ["yes","true"]

  def to_b
    TRUE_VALUES.include?( self.downcase )
  end

end