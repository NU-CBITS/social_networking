module SocialNetworking
  # Manage Goals.
  class GoalsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    def tool
      goals = Goal.where(participant_id: current_participant.id)
      render template: "social_networking/goals/tool",
             locals: {
               goals: Serializers::GoalSerializer.from_collection(goals)
             }
    end

    def index
      goals = Goal.where(participant_id: current_participant.id)

      render json: Serializers::GoalSerializer.from_collection(goals)
    end

    def create
      @goal = Goal.new(sanitized_params)

      if @goal.save
        SharedItem.create(item: @goal, action_type: Goal::Actions.created)
        render json: Serializers::GoalSerializer.new(@goal).to_serialized
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
        if @goal.previous_changes["is_completed"] == [false, true]
          SharedItem.create(item: @goal, action_type: Goal::Actions.completed)
        end
        render json: Serializers::GoalSerializer.new(@goal).to_serialized
      else
        render json: { error: model_errors }, status: 400
      end
    end

    private

    def record_not_found
      render json: { error: "not found" }, status: 404
    end

    def sanitized_params
      s_params = { participant_id: current_participant.id }
      [:description, :isCompleted, :isDeleted, :dueOn].each do |param|
        unless params[param].nil?
          s_params[param.to_s.underscore.to_sym] = params[param]
        end
      end

      s_params
    end

    def model_errors
      @goal.errors.full_messages.join(", ")
    end
  end
end
