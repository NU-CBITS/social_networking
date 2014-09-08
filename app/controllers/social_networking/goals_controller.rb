module SocialNetworking
  # Manage Goals.
  class GoalsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    def index
      goals = Goal.where(participant_id: current_participant.id)

      render json: goals.map { |g| model_json(g) }
    end

    def create
      @goal = Goal.new(sanitized_params)

      if @goal.save
        render json: model_json(@goal)
      else
        render json: { error: model_errors }, status: 400
      end
    end

    def update
      @goal = Goal.where(
        participant_id: current_participant.id,
        id: params[:id]
      ).first || fail(ActiveRecord::RecordNotFound)

      if @goal.update(sanitized_params)
        render json: model_json(@goal)
      else
        render json: { error: model_errors }, status: 400
      end
    end

    private

    def record_not_found
      render json: { error: "not found" }, status: 404
    end

    def sanitized_params
      {
        participant_id: current_participant.id,
        description: params[:description],
        is_completed: params[:isCompleted]
      }
    end

    def model_errors
      @goal.errors.full_messages.join(", ")
    end

    def model_json(model)
      {
        id: model.id,
        participantId: model.participant_id,
        description: model.description,
        isCompleted: model.is_completed
      }
    end
  end
end
