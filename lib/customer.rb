class Customer #aka node
  attr_accessor :name, :neighbors, :costs

  def initialize(name)
    @name = name
    @neighbors = []
    @costs = []
  end
end