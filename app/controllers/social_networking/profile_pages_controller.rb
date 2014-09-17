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
      profile_result = Profile.where(participant_id: current_participant.id)
      if profile_result.empty?
        @profile = Profile.create(participant_id: current_participant.id, active: true)
      else
        @profile = profile_result.first!
      end
      participant = Participant.where(id: @profile.participant_id).first
      @profile.user_name = participant.email
      @profile.last_sign_in = participant.last_sign_in_at
      @profile.active_membership_end_date = participant.active_membership_end_date
    end

    def record_not_found
      render json: { error: "profile not found" }, status: 404
    end
  end
end