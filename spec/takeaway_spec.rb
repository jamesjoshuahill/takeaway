require 'takeaway'

describe Takeaway do
  let(:takeaway) { Takeaway.new }

  it 'should have a list of dishes' do
    dishes = { :tonkatsu => 6, :chashumen => 5, :teriyaki => 4, :edamame => 2 }
    expect(takeaway.dishes).to eq dishes
  end

  it 'should allow an order to be placed' do
    expect(takeaway).to receive(:send_text).and_return true
    expect(takeaway.place_order({ :tonkatsu => 1, :edamame => 2 }, 10)).to be_true
  end

  it 'should raise an error if an order is placed with the wrong total' do
    expect { 
      takeaway.place_order({ :edamame => 2 }, 1)
    }.to raise_error ArgumentError, 'Total is wrong. Please place the order again.'
  end

  it 'should start a new Twilio API client to send text messages' do
    twilio_client = double :TwilioRESTClient
    expect(Twilio::REST::Client).to receive(:new).and_return twilio_client
    expect(takeaway.twilio_client).to be twilio_client
  end

  it 'should use the existing Twilio API client if available' do
    twilio_client = double :TwilioRESTClient
    expect(Twilio::REST::Client).to receive(:new).and_return twilio_client
    takeaway.twilio_client
    expect(takeaway.twilio_client). to be twilio_client
  end

  it 'should be able to send text messages' do
    message = "Thank you!"
    twilio_client = double :TwilioRESTClient
    account = double :account
    sms = double :sms
    messages  = double :messages
    expect(takeaway).to receive(:twilio_client).and_return twilio_client
    expect(twilio_client).to receive(:account).and_return account
    expect(account).to receive(:sms).and_return sms
    expect(sms).to receive(:messages).and_return messages
    expect(messages).to receive(:create) do |message_hash|
      expect(message_hash[:body]).to eq message
    end
    takeaway.send_text(message)
  end

  it 'should send an order confirmation by text' do
    expect(takeaway).to receive(:send_text).and_return true
    takeaway.place_order({ :tonkatsu => 1, :edamame => 2 }, 10)
  end

  it 'should include the delivery time of one hour from now in the text' do
    one_hour_from_now = (Time.now + 60 * 60).strftime("%H:%M")
    expect(takeaway).to receive(:send_text) do |message|
      expect(message).to include one_hour_from_now
    end
    takeaway.place_order({ :tonkatsu => 1, :edamame => 2 }, 10)
  end
end