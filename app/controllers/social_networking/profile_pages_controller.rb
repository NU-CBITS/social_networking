module SocialNetworking
  # Manage Participants.
  class ProfilePagesController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    before_action :set_current_profile

    def index
    end

    def show
    end

    private

    def set_current_profile
      puts '$%^'
      @profile = Profile.where(participant_id: current_participant.id).first
      puts @profile.inspect
    end

    def record_not_found
      render json: { error: "profile not found" }, status: 404
    end
  end
end