class Graph
  attr_accessor :customers

  def initialize
    @customers = []  
  end

  def add_customer(name)
    @customers << Customer.new(name)
  end

  def add_edge(start_name, end_name, cost)
    from = customers.index { |v| v.name == start_name }
    to = customers.index { |v| v.name == end_name }
    customers[from].neighbors[to] = end_name
    customers[from].costs[to] = cost

    build_paths
  end

  def available_route?(route)
    return false if route.one?

    available_route = []
    
    route.each_with_index do |start_name, i|
      if !route[i+1].nil?
        available_route << @paths.dig(start_name).any? { |a| a.include? route[i+1] }
      end
    end

    return available_route.all?
  end
  
  def sum_costs(route)
    return unless available_route?(route)

    costs = []

    route.each_with_index do |start_name, i|
      customer = find_customer_by_name(start_name)
      
      if !route[i+1].nil?
        cost_index = customer.neighbors.index { |n| n == route[i+1] }
        costs << customer.costs[cost_index]
      end
    end

    costs.map(&:to_i).reduce(:+)
  end
  
  def count_routes_arriving(to)
    customers.flat_map(&:neighbors).count(to)
  end

  def search_routes_with_max_stops(start_name, end_name, max_stops, result=[], routes=[])
    result = result+[start_name] # copy and add start_name

    routes << result if (start_name == end_name && available_route?(result))

    @paths[start_name].each do |p|
      if result.size <= max_stops
        search_routes_with_max_stops(p, end_name, max_stops, result, routes)
      end
    end

    routes
  end

  private

  def build_paths
    @paths = {}

    customers.map(&:name).each_with_index do |name, i|
      @paths[name] = customers.map(&:neighbors).map(&:compact).reject(&:empty?)[i]
    end
  end

  def find_customer_by_name(name)
    customers.each do |c|
     return c if c.name == name
    end
    nil
  end
end