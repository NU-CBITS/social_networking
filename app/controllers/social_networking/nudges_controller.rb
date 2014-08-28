module SocialNetworking
  # Manage Nudges.
  class NudgesController < ApplicationController
    def create
      @nudge = Nudge.new(sanitized_params)

      if @nudge.save
        render json: {
          id: @nudge.id,
          initiatorId: @nudge.initiator_id,
          recipientId: @nudge.recipient_id
        }
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
  end
end
