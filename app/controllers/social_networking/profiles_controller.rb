module SocialNetworking
  # Manage Participants.
  class ProfilesController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    def index
      profiles = Profile.all
      profiles = profiles.map do | profile |
        participant = Participant.find(profile.participant_id)
        profile.user_name = participant.email
        profile.latest_action_at = participant.latest_action_at
        profile.active_membership_end_date =
           participant.active_membership_end_date
        profile
      end

      render json: Serializers::ProfileSerializer.from_collection(profiles)
    end

    def show
      profile = Profile.find_or_initialize_by(
         participant_id: current_participant.id)
      profile.update(active: true) if profile.new_record?
      profile.user_name = current_participant.email
      profile.latest_action_at = current_participant.latest_action_at
      profile.active_membership_end_date =
        current_participant.active_membership_end_date

      render json: Serializers::ProfileSerializer.new(profile).to_serialized
    end

    def update
      profile = Profile.find(profile_params[:id])
      profile.icon_name = profile_params[:icon_name]
      profile.save
      profile = Profile.find(profile_params[:id])

      render json: Serializers::ProfileSerializer.new(profile).to_serialized
    end

    private

    def profile_params
      params.permit(:profile, :id, :icon_name)
    end

    def record_not_found
      render json: { error: "profile not found" }, status: 404
    end
  end
end
