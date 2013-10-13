Takeaway
========

### Makers Academy week 4 test

This test was set by Enrique Comba Riepenhausen
[@ecomba](http://twitter.com/ecomba) whilst learning to code at
[Makers Academy](http://www.makersacademy.com). The aim was to build a
model of a takeaway in Ruby and use the
[Twilio API](https://www.twilio.com/sms/api) to send text messages.

I bundled the [`twilio-ruby`](https://github.com/twilio/twilio-ruby) gem and
wrote this code using RSpec for TDD.

To run this code yourself please sign up for a free Twilio account and create a
`lib/twilio-credentials.rb` file with your own credentials as follows:

```ruby
module TwilioCredentials
  ACCOUNT_SID = ''
  AUTH_TOKEN = ''
  FROM_NUMBER = ''
  TO_NUMBER = ''
end
```

This code could be improved by writing a `TwilioAPIWrapper` class, so that the
tests are separated logically from any changes in the API specification.

In addition, the `Takeaway` class could be broken up to make adding further
functionality would be easier.
