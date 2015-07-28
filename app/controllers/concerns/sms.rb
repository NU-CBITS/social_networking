require "rubygems"
require "twilio-ruby"

# A set of utility methods used in relation to SMS notifications
# @author Eric Schlange <eric.schlange@northwestern.edu>
module Sms
  extend ActiveSupport::Concern

  # Send an SMS message body to a specified receiving participant (leaving
  # off recipient defaults the value to the current participant)
  # rubocop:disable Metrics/AbcSize
  def send_sms(recipient = current_user, message_body)
    return if recipient.phone_number.blank?

    logger.info "INFO BEFORE: SMS notification sent "\
                "to: #{recipient.phone_number}"
    if recipient.is_a?(Participant)
      if Rails.env.staging? || Rails.env.production?
        client = Twilio::REST::Client.new(
          Rails.application.config.twilio_account_sid,
          Rails.application.config.twilio_auth_token)
        account = client.account
        account.messages.create(message_attributes(recipient, message_body))
      else
        logger.info "INFO - SMS attributes: "\
                    "#{message_attributes(recipient, message_body)}"
      end
    else
      logger.error "Error: Expected recipient to be a Participant."
    end
    logger.info "INFO AFTER: SMS notification sent "\
                "to: #{recipient.phone_number}"
  end
  # rubocop:enable Metrics/AbcSize

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
