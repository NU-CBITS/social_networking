module SocialNetworking
  # Manage Participants.
  class ParticipantsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    def index
      participants = Participant.all

      render json: participants.map { |p| model_json(p) }
    end

    def show
      participant = Participant.find(params[:id])

      render json: model_json(participant)
    end

    private

    def model_json(model)
      {
        id: model.id,
        username: model.email,
        lastLogin: model.last_sign_in_at
      }
    end

    def record_not_found
      render json: { error: "participant not found" }, status: 404
    end
  end
end
