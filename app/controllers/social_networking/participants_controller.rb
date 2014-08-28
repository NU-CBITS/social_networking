module SocialNetworking
  # Manage Participants.
  class ParticipantsController < ApplicationController
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
  end
end
