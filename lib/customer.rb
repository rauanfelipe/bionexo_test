class Customer #aka node
  attr_accessor :name, :neighbors, :expenses

  def initialize(name)
    @name = name
    @neighbors = []
    @expenses = []
  end
end