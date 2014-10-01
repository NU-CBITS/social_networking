module SocialNetworking
  # Manage Participants.
  class ProfilesController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    def index
      profiles = Profile.all
      profiles = profiles.map do | profile |
        participant = Participant.find(profile.participant_id)
        profile.user_name = participant.email
        profile.last_sign_in = participant.last_sign_in_at
        profile.active_membership_end_date =
           participant.active_membership_end_date
        profile
      end

      puts profiles.inspect

      render json: Serializers::ProfileSerializer.from_collection(profiles)
    end

    def show
      profile = Profile.find_or_initialize_by(
         participant_id: current_participant.id)
      profile.update(active: true) if profile.new_record?
      profile.user_name = current_participant.email
      profile.last_sign_in = current_participant.last_sign_in_at
      profile.active_membership_end_date =
        current_participant.active_membership_end_date

      render json: Serializers::ProfileSerializer.new(profile).to_serialized
    end

    private

    def record_not_found
      render json: { error: "profile not found" }, status: 404
    end
  end
end
