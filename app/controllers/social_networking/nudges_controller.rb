# Controller used to Manage Nudges.

require "rubygems"
require "twilio-ruby"

module SocialNetworking

  class NudgesController < ApplicationController
    include ItemUtilities
    include SMSUtilities

    def index
      @nudges = Nudge.search(sanitized_params[:recipient_id])
      render json: Serializers::NudgeSerializer.from_collection(@nudges)
    end

    # Create a new nudge and notify the recipient
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

    # Select message from list, determine contact preference, then
    # trigger the notification based on the preference.
    def notify
      recipient = Participant.find(sanitized_params[:recipient_id])

      message_body = [
        "You've been nudged by #{recipient.email}! Log in (#{root_url}) to find out who nudged you.",
        "#{recipient.email} just nudged you! Log in (#{root_url}) to view your nudge!",
        "Hey! #{recipient.email} nudged you! Don't leave them hanging - log in (#{root_url}) to say hi!",
        "Looks like #{recipient.email}'s thinking about you! Log in (#{root_url}) to see who nudged you.",
        "Psst - you've been nudged by #{recipient.email}! Log in (#{root_url}) to support a fellow group member!"
      ].sample

      if "email" == recipient.contact_preference
        send_notify_email(@nudge, message_body)
      elsif "sms" == recipient.contact_preference &&
        recipient.phone_number &&
        !recipient.phone_number.blank?
        send_sms(recipient, message_body)
      end
    end

    def model_errors
      @nudge.errors.full_messages.join(", ")
    end

    # Trigger nudge notification email
    def send_notify_email(nudge, message_body)
      NudgeMailer.nudge_email_alert(
        recipient: Participant.find( nudge.recipient_id),
        message_body: message_body,
        subject: "You were nudged!")
    end

  end
end
