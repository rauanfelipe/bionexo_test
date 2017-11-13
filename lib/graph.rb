class Graph
  attr_accessor :customers

  def initialize
    @customers = []
  end

  def add_customer(name)
    @customers << Customer.new(name)
  end

  def add_edge(start_name, end_name, expense)
    from = customers.index { |v| v.name == start_name }
    to = customers.index { |v| v.name == end_name }
    customers[from].neighbors[to] = end_name
    customers[from].expenses[to] = expense

    set_paths
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

  def sum_expenses(route)
    return 0 unless available_route?(route)

    all_expenses = []

    route.each_with_index do |start_name, i|
      customer = find_customer_by_name(start_name)

      if !route[i+1].nil?
        expense_index = customer.neighbors.index { |n| n == route[i+1] }
        all_expenses << customer.expenses[expense_index]
      end
    end

    all_expenses.map(&:to_i).reduce(:+)
  end

  def count_routes_arriving(to)
    customers.flat_map(&:neighbors).count(to)
  end

  def count_routes_with_stops(start_name, end_name, stops, result=[], routes=[])
    result = result+[start_name]

    routes << result if (start_name == end_name && available_route?(result))

    @paths[start_name].each do |p|
      count_routes_with_max_stops(p, end_name, stops, result, routes)
    end

    routes.map { |route| route.size == (stops + 1) }.count(true)
  end

  def count_routes_with_max_stops(start_name, end_name, max_stops, result=[], routes=[])
    result = result+[start_name]

    routes << result if (start_name == end_name && available_route?(result))

    @paths[start_name].each do |p|
      if result.size <= max_stops
        count_routes_with_max_stops(p, end_name, max_stops, result, routes)
      end
    end

    routes.size
  end

  def search_routes_cheaper(start_name, end_name, expense, result=[], routes=[])
    result = result+[start_name] # copy and add start_name

    routes << result if (start_name == end_name && available_route?(result))

    @paths[start_name].each do |p|
      if (sum_expenses(result) < expense)
        search_routes_cheaper(p, end_name, expense, result, routes)
      end
    end

    routes.select { |r| sum_expenses(r) < expense }.size
  end

  def shortest_route(start_name, end_name) # dijkstra
    start_index = customers.index { |v| v.name == start_name }
    end_index   = customers.index { |v| v.name == end_name }

    # 1.0/0.0 = Float::Infinity
    infinity = 1.0/0.0

    expenses = Array.new(customers.size, infinity)
    expenses[start_index] = 0
    visited = []

    customers.size.times do
      # locate unvisited customer with minimum expenses, then mark it visited
      min = infinity
      current = 0
      expenses.each_with_index do |distance, i|
        if distance < min && !visited[i]
          min = distance
          current = i
        end
      end
      visited[current] = true

      # check whether path from chosen customer to each of its neighbors results in a new minimum
      customers[current].neighbors.each_with_index do |neighbor, i|
        if neighbor && (expenses[current] + customers[current].expenses[i].to_i < expenses[i])
          expenses[i] = expenses[current] + customers[current].expenses[i].to_i
        end
      end
    end

    expenses[end_index]
  end

  private

  def set_paths
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