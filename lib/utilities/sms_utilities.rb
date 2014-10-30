# A set of utility methods used in relation to SMS notifications
# @author Eric Schlange <eric.schlange@northwestern.edu>
module SMSUtilities
  # Send an SMS message body to a specified reciving participant (leaving
  # off recipient defaults the value to the current participant)
  def send_sms(recipient = current_user, message_body)
    if value.is_a?(Participant)
      client = Twilio::REST::Client.new(
        Rails.application.config.twilio_account_sid,
        Rails.application.config.twilio_auth_token)
      account = client.account
      account.sms.messages.create(
        from:
          "+#{Rails.application.config.twilio_account_telephone_number}",
        to:
          "+#{recipient.phone_number}",
        body:
          message_body
      )
    else
      logger.error "Error: Expected recipient to be a Participant."
    end
  end
end
