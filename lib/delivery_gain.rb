require_relative 'customer'
require_relative 'graph'

class DeliveryGain
  attr_accessor :graph, :default_routes

  def self.process(graph)
    new(graph).process
  end

  def initialize(graph)
    @default_routes = graph.flatten.map { |a| a.scan /\w/ }

    build_graph
  end
  
  def build_graph
    customers =  @default_routes.flat_map { |r| r.take 2 }.uniq

    @graph = Graph.new
    customers.each do |customer|
      @graph.add_customer(customer)
    end

    @default_routes.each do |route|
      @graph.add_edge(*route)
    end
  end
  
  def process
    arr = []

    #1. The cost of the route A-D-E.
    #2. The cost of the route A-F-E.
    #3. The cost of the route E-C-B.
    #4. The cost of the route B-D-F-E.
    #5. The cost of the route F-C.
    arr << -> { sum_cost(['A', 'D', 'E']) }
    arr << -> { sum_cost(['A', 'F', 'E']) }
    arr << -> { sum_cost(['E', 'C', 'B']) }
    arr << -> { sum_cost(['B', 'D', 'F', 'E']) }
    arr << -> { sum_cost(['F', 'C']) }

    #6. How many routes are arriving the client `C`
    arr << -> { @graph.count_routes_arriving('C') }

    # 7. How many routes start at the client `B` and end at the client `A` with a maximum of 5 stops. 
    arr << -> { @graph.search_routes_with_max_stops('B', 'A', 5).size }

    # 8. How many routes start at the client `A` and end at the client `A` with exactly 3 stops.
    arr << -> { @graph.search_routes_with_max_stops('A', 'A', 3).size }

    arr.map &:call
  end

  def sum_cost(route)
    return 'NO SUCH ROUTE' unless @graph.available_route?(route)

    @graph.sum_costs(route)
  end
end