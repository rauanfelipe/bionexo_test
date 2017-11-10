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
  end

  def available_route?(route)
    available_route = []
    
    customer_routes = {}
    route.each_with_index do |start_name, i|
      customer = find_customer_by_name(start_name)
      customer_routes[start_name] = customer.costs.zip(customer.neighbors).map(&:compact).reject(&:empty?)
      
      if !route[i+1].nil?
        available_route << customer_routes.dig(start_name).any? { |a| a.include? route[i+1] } 
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

  def find_customer_by_name(name)
    customers.each do |c|
     return c if c.name == name
    end
    nil
  end
end