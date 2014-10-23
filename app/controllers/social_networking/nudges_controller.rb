require "rubygems"
require "twilio-ruby"

module SocialNetworking
  # Manage Nudges.
  class NudgesController < ApplicationController
    def index
      @nudges = Nudge.search(sanitized_params[:recipient_id])

      render json: Serializers::NudgeSerializer.from_collection(@nudges)
    end

    def create
      @nudge = Nudge.new(sanitized_params)

      if @nudge.save
        notify
        render json: Serializers::NudgeSerializer.new(@nudge).to_serialized
      else
        render json: { error: model_errors }, status: 400
      end
    end

    private

    def sanitized_params
      {
        initiator_id: current_participant.id,
        recipient_id: params[:recipientId]
      }
    end

    def notify
      recipient = Participant.find(sanitized_params[:recipient_id])

      if "email" == recipient.contact_preference
        send_notify_email(@nudge)
      elsif "sms" == recipient.contact_preference &&
        recipient.phone_number &&
        !recipient.phone_number.blank?
        send_notify_sms(recipient)
      end
    end

    def model_errors
      @nudge.errors.full_messages.join(", ")
    end

    def send_notify_email(nudge)
      NudgeMailer.nudge_email_alert(
        Participant.find(nudge.recipient_id), current_participant)
    end

    def send_notify_sms(recipient)
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
          "#{current_participant.email} has nudged you. \
                  Come back to MoodTech (#{root_url})."
      )
    end
  end
end
