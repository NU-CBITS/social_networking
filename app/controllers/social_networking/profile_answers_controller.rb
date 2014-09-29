module SocialNetworking
  # Manage Participants.
  class ProfileAnswersController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    def index
      profile_id = profile_answer_params[:profile_id]
      question_id = profile_answer_params[:profile_question_id]

      if profile_id.present? && question_id.present?
        answer = ProfileAnswer
          .where(social_networking_profile_id: profile_id,
                 social_networking_profile_question_id: question_id)
          .first
      end

      render json: Serializers::ProfileAnswerSerializer.new(answer)
                     .to_serialized
    end

    def show
    end

    def create
      @profile_answer = ProfileAnswer.new(profile_answer_params)

      if @profile_answer.save
        render json: Serializers::ProfileAnswerSerializer.new(@profile_answer)
                       .to_serialized
      else
        render json: { error: model_errors }, status: 400
      end
    end

    def update
      @profile_answer = ProfileAnswer.where(id: id).first! ||
         fail(ActiveRecord::RecordNotFound)

      if @profile_answer.update(profile_answer_params)
        render json: Serializers::ProfileAnswerSerializer.new(@profile_answer)
                       .to_serialized
      else
        render json: { error: model_errors }, status: 400
      end
    end

    private

    def profile_answer_params
      s_params = { participant_id: current_participant.id }
      [:profile_id, :profile_question_id, :id].each do |param|

        unless params[param].nil?
          s_params[param.to_s.underscore.to_sym] = params[param]
        end
      end

      s_params
    end

    def record_not_found
      render json: { error: "profile not found" }, status: 404
    end
  end
end
