module SocialNetworking
  # Manage Nudges.
  class NudgesController < ApplicationController
    def index
      @nudges = Nudge.search(sanitized_params[:recipient_id])

      render json: Serializers::NudgeSerializer.from_collection(@nudges)
    end

    def create
      @nudge = Nudge.new(sanitized_params)
      puts params.inspect

      if @nudge.save
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

    def model_errors
      @nudge.errors.full_messages.join(", ")
    end
  end
end
