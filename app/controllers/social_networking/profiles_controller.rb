module SocialNetworking
  # Manage Participants.
  class ProfilesController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    def index
      profiles = Profile.all

      render json: profiles.map { |p| model_json(p) }
    end

    def show
      profile = Profile.find(params[:id])

      render json: model_json(profile)
    end

    private

    def model_json(model)
      {
        id: model.id,
        username: model.participant.email,
        lastLogin: model.participant.last_sign_in_at,
        endOfTrial: model.participant.active_membership_end_date
      }
    end

    def record_not_found
      render json: { error: "profile not found" }, status: 404
    end
  end
end
