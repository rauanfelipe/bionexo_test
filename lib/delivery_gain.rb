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

  def sum_expenses(route)
    return 'NO SUCH ROUTE' unless @graph.available_route?(route)

    @graph.sum_expenses(route)
  end

  def process
    arr = []

    #1. The cost of the route A-D-E.
    arr << -> { sum_expenses(['A', 'D', 'E']) }

    #2. The cost of the route A-F-E.
    arr << -> { sum_expenses(['A', 'F', 'E']) }

    #3. The cost of the route E-C-B.
    arr << -> { sum_expenses(['E', 'C', 'B']) }

    #4. The cost of the route B-D-F-E.
    arr << -> { sum_expenses(['B', 'D', 'F', 'E']) }

    #5. The cost of the route F-C.
    arr << -> { sum_expenses(['F', 'C']) }

    #6. How many routes are arriving the client `C`
    arr << -> { @graph.count_routes_arriving('C') }

    # 7. How many routes start at the client `B` and end at the client `A` with a maximum of 5 stops.
    arr << -> { @graph.search_routes_with_max_stops('B', 'A', 5) }

    # 8. How many routes start at the client `A` and end at the client `A` with exactly 3 stops.
    arr << -> { not_implemented }

    # 9. The cost of the shortest route between the clients `A` and `E`.
    arr << -> { @graph.shortest_route('A', 'E') }

    # 10. The cost of the shortest route between the clients `C` and `E`.
    arr << -> { @graph.shortest_route('C', 'E') }

    # 11. The number of different routes between the clients `A` and `B` that costs less than 40.
    arr << -> { @graph.search_routes_cheaper('A', 'B', 40) }

    # 12. The number of different routes between the clients `E` and `D` that costs less than 60.
    arr << -> { @graph.search_routes_cheaper('E', 'D', 60) }

    arr.map &:call
  end

  private

  def not_implemented
    return 'NOT IMPLEMENTED'
  end
end