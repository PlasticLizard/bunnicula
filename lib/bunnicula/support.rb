class Object
  def to_b
    !!(self)
  end
end

class Array
  def extract_options!
    last.is_a?(::Hash) ? pop : {}
  end
end