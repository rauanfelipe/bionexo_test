require 'graph'
require 'delivery_gain'
require 'pry'

RSpec.describe Graph do
  let(:graph) { ['AD4', 'DE1', 'EC8', 'CB2', 'BA6', 'AC9', 'DF7', 'FC5', 'FE9', 'BD3', 'FA3'] }

  subject { DeliveryGain.new(graph).graph }

  context '#available_route?' do
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

  context '#sum_costs' do
    context 'with no available route' do
      it do
        route = ['A', 'F', 'E']
        expect(subject.sum_costs(route)).to be_nil
      end
    end

    context 'with available route' do
      it do
        route = ['A', 'D', 'E']
        expect(subject.sum_costs(route)).to eq 5
      end

      it do
        route = ['F', 'C']
        expect(subject.sum_costs(route)).to eq 5
      end

      it do
        route = ['B', 'D', 'F', 'E']
        expect(subject.sum_costs(route)).to eq 19
      end

      it do
        route = ['E', 'C', 'B']
        expect(subject.sum_costs(route)).to eq 10
      end
    end
  end
end