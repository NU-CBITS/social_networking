module SocialNetworking
  # Manage Participants.
  class ProfileAnswersController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    def index
      if !profile_answer_params[:profile_id].blank? &&
         !profile_answer_params[:profile_question_id].blank?

        answer = ProfileAnswer.where(social_networking_profile_id: profile_answer_params[:profile_id],
                                     social_networking_profile_question_id: profile_answer_params[:profile_question_id]).first
      end

      if answer
        render json: Serializers::ProfileAnswerSerializer.new(answer).to_serialized
      else
        render json: {}, status: 404
      end
    end

    def show
    end

    def create
      @profile_answer = ProfileAnswer.new(
         social_networking_profile_id: profile_answer_params[:profile_id],
         social_networking_profile_question_id: profile_answer_params[:profile_question_id],
         answer_text: profile_answer_params[:answer_text]
      )

      if @profile_answer.save
        render json: Serializers::ProfileAnswerSerializer.new(@profile_answer).to_serialized
      else
        render json: { error: model_errors }, status: 400
      end
    end

    def update
      @profile_answer = ProfileAnswer.where(id: profile_answer_params[:id]).first! ||
         fail(ActiveRecord::RecordNotFound)

      if @profile_answer.update(answer_text: profile_answer_params[:answer_text])
        render json: Serializers::ProfileAnswerSerializer.new(@profile_answer).to_serialized
      else
        render json: { error: model_errors }, status: 400
      end
    end

    private

    def profile_answer_params
      params.permit(:profile_id, :profile_question_id, :id, :answer_text, :profile_answer);
    end

    def model_errors
      @profile_answer.errors.full_messages.join(", ")
    end

    def record_not_found
      render json: { error: "profile not found" }, status: 404
    end
  end
end
