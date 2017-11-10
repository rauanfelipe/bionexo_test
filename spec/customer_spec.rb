require 'customer'

RSpec.describe Customer do
  it do
    customer = described_class.new('FOO')
    expect(customer.name).to eq 'FOO'
  end
end