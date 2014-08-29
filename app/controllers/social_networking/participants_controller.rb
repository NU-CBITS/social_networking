module SocialNetworking
  # Manage Participants.
  class ParticipantsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    def index
      render json: (Participant.all.map do |p|
        {
          id: p.id,
          username: p.email,
          lastLogin: p.last_sign_in_at
        }
      end)
    end

    def show
      @participant = Participant.find(params[:id])

      render json: {
        id: @participant.id,
        username: @participant.email,
        lastLogin: @participant.last_sign_in_at
      }
    end

    private

    def record_not_found
      render json: { error: "participant not found" }, status: 404
    end
  end
end
