# Controller used to Manage Nudges.
module SocialNetworking
  # Manage Nudges.
  class NudgesController < ApplicationController
    before_action :set_recipient

    def index
      @nudges = Nudge.search(sanitized_params[:recipient_id])
      render json: Serializers::NudgeSerializer.from_collection(@nudges)
    end

    def create
      @nudge = Nudge.new(sanitized_params)

      if @nudge.save
        build_notification.notify
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

    def model_errors
      @nudge.errors.full_messages.join(", ")
    end

    def build_notification
      Notification.new(
        current_participant: current_participant,
        mailer: Mailer,
        recipient: @recipient,
        message_body: message_body,
        subject: "You've been NUDGED on "\
          "#{t('application_name', default: 'ThinkFeelDo')}")
    end

    def message_body
      profile_url = social_networking_profile_url
      ["You've been nudged by #{current_participant.display_name}! Log \
in (#{profile_url}) to find out who nudged you.",
       "#{current_participant.display_name} just nudged you! Log in \
(#{profile_url}) to view your nudge!",
       "Hey! #{current_participant.display_name} nudged you! Don't leave \
them hanging - log in (#{profile_url}) to say hi!",
       "Looks like #{current_participant.display_name}'s thinking about you! \
Log in (#{profile_url}) to see who nudged you.",
       "Psst - you've been nudged by #{current_participant.display_name}! \
Log in (#{profile_url}) to support a fellow group member!"].sample
    end

    def set_recipient
      @recipient = Participant.find(sanitized_params[:recipient_id])
    end
  end
end
