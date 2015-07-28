# Controller used to Manage Nudges.
module SocialNetworking
  # Manage Nudges.
  class NudgesController < ApplicationController
    before_action :set_recipient
    include Sms

    def index
      @nudges = Nudge.search(sanitized_params[:recipient_id])
      render json: Serializers::NudgeSerializer.from_collection(@nudges)
    end

    # Create a new nudge and notify the recipient
    def create
      @nudge = Nudge.new(sanitized_params)

      if !@recipient.contact_preference
        render json: { message: "This participant can't be nudged." }
      elsif @nudge.save
        render json: { message: "Nudge sent!" }
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
      case @recipient.contact_preference
      when "email"
        send_notify_email
      when "sms", "phone"
        send_sms(@recipient, message_body) if @recipient.phone_number.present?
      else
        logger.error "ERROR: contact preference is not set for \
        participant with ID: #{@recipient.id}"
      end
    end

    def model_errors
      @nudge.errors.full_messages.join(", ")
    end

    # Trigger nudge notification email
    def send_notify_email
      NudgeMailer.nudge_email_alert(
        @recipient,
        message_body,
        "You've been NUDGED on "\
        "#{t('application_name', default: 'ThinkFeelDo')}").deliver
    end

    def set_recipient
      @recipient = Participant.find(sanitized_params[:recipient_id])
    end

    def message_body
      site_root_url = social_networking_profile_url
      ["You've been nudged by #{current_participant.display_name}! Log \
in (#{site_root_url}) to find out who nudged you.",
       "#{current_participant.display_name} just nudged you! Log in \
(#{site_root_url}) to view your nudge!",
       "Hey! #{current_participant.display_name} nudged you! Don't leave \
them hanging - log in (#{site_root_url}) to say hi!",
       "Looks like #{current_participant.display_name}'s thinking about you! \
Log in (#{site_root_url}) to see who nudged you.",
       "Psst - you've been nudged by #{current_participant.display_name}! \
Log in (#{site_root_url}) to support a fellow group member!"].sample
    end
  end
end
