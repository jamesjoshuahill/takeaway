require 'takeaway'

describe Takeaway do

  let(:takeaway) { Takeaway.new }

  context 'should have a menu' do

    it 'with a list of dishes' do
      dishes = { :tonkatsu => 6,
                 :chashumen => 5,
                 :teriyaki => 4,
                 :edamame => 2 }

      expect(takeaway.dishes).to eq dishes
    end

  end

  context 'should be able to send texts' do

    let(:twilio_client) { double :TwilioRESTClient }

    it 'using a new Twilio API client' do
      expect(Twilio::REST::Client).to receive(:new).and_return twilio_client

      expect(takeaway.twilio_client).to be twilio_client
    end

    it 'using the current Twilio API client' do
      expect(Twilio::REST::Client).to receive(:new).and_return twilio_client

      takeaway.twilio_client

      expect(takeaway.twilio_client). to be twilio_client
    end

    it 'with a message' do
      message = "Thank you!"
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

  end

  context 'should receive' do

    context 'incorrect orders and' do

      it 'raise an error if the total is wrong' do
        expect {
          takeaway.place_order({ :edamame => 2 }, 1)
        }.to raise_error(ArgumentError,
          'Total is wrong. Please place the order again.')
      end

    end

    context 'correct orders and' do

      let(:place_correct_order) { takeaway.place_order({ :tonkatsu => 1,
                                                         :edamame => 2 },
                                                         10) }

      it 'place them' do
        expect(takeaway).to receive(:send_text).and_return true

        expect(takeaway.place_order({ :tonkatsu => 1, :edamame => 2 }, 10)).to be_true
      end

      it 'send an order confirmation by text' do
        expect(takeaway).to receive(:send_text).and_return true

        place_correct_order
      end

      it 'confirm the delivery time of one hour from now' do
        one_hour_from_now = (Time.now + 60 * 60).strftime("%H:%M")
        expect(takeaway).to receive(:send_text) do |message|
          expect(message).to include one_hour_from_now
        end

        place_correct_order
      end

    end

  end

end
