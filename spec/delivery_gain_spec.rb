require 'delivery_gain'
require 'pry'

RSpec.describe DeliveryGain do
  let(:graph) { ['AD4', 'DE1', 'EC8', 'CB2', 'BA6', 'AC9', 'DF7', 'FC5', 'FE9', 'BD3', 'FA3'] }

  describe '#sum_cost' do
    context 'with no available route' do
      let(:route) { ['A', 'F', 'E'] }

      it do
        subject = described_class.new(graph)
        expect(subject.sum_expenses(route)).to eq 'NO SUCH ROUTE'
      end
    end

    context 'with available route' do
      let(:route) { ['A', 'D', 'E'] }

      it do
        subject = described_class.new(graph)
        expect(subject.sum_expenses(route)).to eq 5
      end
    end
  end

  describe '#process' do
    let(:outputs) { [5, 'NO SUCH ROUTE', 10, 19, 5, 3, 6, 2, 5, 6, 27, 137] }
    subject { described_class }

    it do
      expect(subject.process(graph)).to eq outputs
    end
  end
end