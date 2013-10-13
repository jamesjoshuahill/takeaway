require 'bundler/setup'
require 'twilio-ruby'
require_relative 'twilio-credentials'

class Takeaway
  
  def dishes
    { :tonkatsu => 6,
      :chashumen => 5,
      :teriyaki => 4,
      :edamame => 2 }
  end

  def place_order(dishes_and_quantities, order_total)
    actual_price = check_price_of(dishes_and_quantities)
    raise_order_total_error if actual_price != order_total
    send_order_confirmation
  end

  def send_order_confirmation
    one_hour_from_now = (Time.now + 60 * 60).strftime("%H:%M")
    order_confirmation = "Thank you! Your order was successfully " +
     "placed and will be delivered before #{one_hour_from_now}"
    send_text(order_confirmation)
  end

  def check_price_of(dishes_and_quantities)
    dishes_and_quantities.inject(0) do |price, (dish, quantity)|
      price += dishes[dish] * quantity
    end
  end

  def raise_order_total_error
    raise ArgumentError, 'Total is wrong. Please place the order again.'
  end

  def twilio_client
    account_sid = TwilioCredentials::ACCOUNT_SID
    auth_token = TwilioCredentials::AUTH_TOKEN
    @twilio_client ||= Twilio::REST::Client.new account_sid, auth_token
  end

  def send_text(message)
    twilio_client.account.sms.messages.create(
      :from => TwilioCredentials::FROM_NUMBER,
      :to => TwilioCredentials::TO_NUMBER,
      :body => message)
  end

end
