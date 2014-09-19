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
      @profile =
        Profile.find_or_initialize_by(participant_id: current_participant.id)
      if @profile.id.nil?
        @profile.active = true
        @profile.save
      end
      @profile.user_name = current_participant.email
      @profile.last_sign_in = current_participant.last_sign_in_at
      @profile.active_membership_end_date = current_participant.active_membership_end_date
    end

    def record_not_found
      render json: { error: "profile not found" }, status: 404
    end
  end
end
