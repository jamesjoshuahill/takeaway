require 'takeaway'

describe Takeaway do
  let(:takeaway) { Takeaway.new }

  it 'should have a list of dishes' do
    dishes = { :tonkatsu => 6, :chashumen => 5, :teriyaki => 4, :edamame => 2 }
    expect(takeaway.dishes).to eq dishes
  end

  it 'should allow an order to be placed' do
    expect(takeaway.place_order({ :tonkatsu => 1, :edamame => 2 }, 10)).to be_true
  end

  it 'should raise an error if an order is placed with the wrong total' do
    expect { 
      takeaway.place_order({ :edamame => 2 }, 1)
    }.to raise_error ArgumentError, 'Total is wrong. Please place the order again.'
  end

  it 'should send an order confirmation by text if an order is placed correctly'
end