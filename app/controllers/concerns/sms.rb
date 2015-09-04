require "rubygems"
require "twilio-ruby"

# A set of utility methods used in relation to SMS notifications
module Sms
  extend ActiveSupport::Concern

  def send_sms(recipient = current_user, message_body)
    return unless Rails.env.staging? || Rails.env.production?
    return if recipient.phone_number.try(:blank?)
    client = Twilio::REST::Client.new(
      Rails.application.config.twilio_account_sid,
      Rails.application.config.twilio_auth_token)
    account = client.account
    account.messages.create(message_attributes(recipient, message_body))
  end

  private

  def message_attributes(recipient, body)
    {
      from:
        "#{Rails.application.config.twilio_account_telephone_number}",
      to:
        "+#{recipient.phone_number}",
      body:
        body
    }
  end
end
