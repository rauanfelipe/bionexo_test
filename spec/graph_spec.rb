require 'graph'
require 'delivery_gain'
require 'pry'

RSpec.describe Graph do
  let(:graph) { ['AD4', 'DE1', 'EC8', 'CB2', 'BA6', 'AC9', 'DF7', 'FC5', 'FE9', 'BD3', 'FA3'] }

  subject { DeliveryGain.new(graph).graph }

  describe '#shortest_route' do
    let(:start_name) { 'A' }
    let(:end_name) { 'E' }

    it { expect(subject.shortest_route(start_name, end_name)).to eq 5 }
  end

  describe '#search_routes_with_max_stops' do
    let(:start_name) { 'B' }
    let(:end_name) { 'A' }
    let(:max_stops) { 5 }

    it do
      routes = subject.search_routes_with_max_stops(start_name, end_name, max_stops)
      expect(routes).to eq 6
    end
  end

  describe '#count_routes_arriving' do
    it do
      expect(subject.count_routes_arriving('A')).to eq 2
      expect(subject.count_routes_arriving('C')).to eq 3
    end
  end

  describe '#available_route?' do
    context 'with available route' do
      it do
        route = ['A', 'D', 'E']
        expect(subject.available_route?(route)).to be_truthy
      end
    end

    context 'with no available route' do
      it do
        route = ['A', 'F', 'E']
        expect(subject.available_route?(route)).to be_falsey
      end
    end
  end

  describe '#sum_expenses' do
    context 'with no available route' do
      it do
        route = ['A', 'F', 'E']
        expect(subject.sum_expenses(route)).to be_nil
      end
    end

    context 'with available route' do
      it do
        route = ['A', 'D', 'E']
        expect(subject.sum_expenses(route)).to eq 5
      end

      it do
        route = ['F', 'C']
        expect(subject.sum_expenses(route)).to eq 5
      end

      it do
        route = ['B', 'D', 'F', 'E']
        expect(subject.sum_expenses(route)).to eq 19
      end

      it do
        route = ['E', 'C', 'B']
        expect(subject.sum_expenses(route)).to eq 10
      end
    end
  end
end