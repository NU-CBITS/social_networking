# Controller used to Manage Nudges.
module SocialNetworking
  # Manage Nudges.
  class NudgesController < ApplicationController
    include Sms

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
    # rubocop:disable Metrics/AbcSize
    def notify
      recipient = Participant.find(sanitized_params[:recipient_id])

      case recipient.contact_preference
      when "email"
        send_notify_email(@nudge, message_body)
      when "sms"
        if recipient.phone_number && !recipient.phone_number.blank?
          send_sms(recipient, message_body)
        end
      else
        logger.error "ERROR: contact preference is not set for \
        participant with ID: " + recipient.id
      end
    end
    # rubocop:enable Metrics/AbcSize

    def model_errors
      @nudge.errors.full_messages.join(", ")
    end

    # Trigger nudge notification email
    def send_notify_email(nudge, message_body)
      NudgeMailer.nudge_email_alert(
        Participant.find(nudge.recipient_id),
        message_body,
        "You were nudged!")
    end

    def message_body
      site_root_url = root_url
      ["You've been nudged by #{current_participant.email}! Log \
in (#{site_root_url}) to find out who nudged you.",
       "#{current_participant.email} just nudged you! Log in \
(#{site_root_url}) to view your nudge!",
       "Hey! #{current_participant.email} nudged you! Don't leave \
them hanging - log in (#{site_root_url}) to say hi!",
       "Looks like #{current_participant.email}'s thinking about you! \
Log in (#{site_root_url}) to see who nudged you.",
       "Psst - you've been nudged by #{current_participant.email}! \
Log in (#{site_root_url}) to support a fellow group member!"].sample
    end
  end
end
