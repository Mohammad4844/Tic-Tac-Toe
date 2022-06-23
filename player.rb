class Player
  attr_reader :name, :selector

  def initialize(name, selector)
    @name = name
    @selector = selector
  end
end