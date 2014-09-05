module SocialNetworking
  # Manage Goals.
  class GoalsController < ApplicationController
    def create
      @goal = Goal.new(sanitized_params)

      if @goal.save
        render json: {
          id: @goal.id,
          participantId: @goal.participant_id,
          description: @goal.description
        }
      else
        render json: { error: model_errors }, status: 400
      end
    end

    private

    def sanitized_params
      {
        participant_id: current_participant.id,
        description: params[:description]
      }
    end

    def model_errors
      @goal.errors.full_messages.join(", ")
    end
  end
end
