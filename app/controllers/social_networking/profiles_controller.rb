module SocialNetworking
  # Manage Participants.
  class ProfilesController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    def index
      profiles = Profile.all

      render json: Serializers::ProfileSerializer.from_collection(profiles)
    end

    def show
      profile = Profile.find(params[:id])

      render json: Serializers::ProfileSerializer.new(profile).to_serialized
    end

    private

    def record_not_found
      render json: { error: "profile not found" }, status: 404
    end
  end
end
