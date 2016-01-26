require_dependency "social_networking/application_controller"

module SocialNetworking
  # Manage Participants.
  class ProfilesController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    def index
      group_participants = current_participant.active_group.active_participants
      render json: Serializers::ProfileSerializer.from_collection(Profile
        .where(participant_id: group_participants.pluck(:id)))
    end

    def show
      if params[:id]
        profile = Profile.find(params[:id])
      else
        profile = Profile
                  .find_or_initialize_by(
                    participant_id: current_participant.id) do |profile_new|
          begin
            SharedItem.create(
              item: profile_new,
              action_type: Profile::Actions.created)
          rescue ActiveRecord::StatementInvalid
            logger.info("Shared item already created for existing profile.")
          end
        end
      end

      render json: Serializers::ProfileSerializer.new(profile).to_serialized
    end

    def update
      profile = current_participant.social_networking_profile
      if profile.update(profile_params)
        render json: Serializers::ProfileSerializer.new(profile).to_serialized
      else
        render json: { error: profile.errors.full_messages }, status: 400
      end
    end

    private

    def profile_params
      params.permit(:icon_name)
    end

    def record_not_found
      render json: { error: "profile not found" }, status: 404
    end
  end
end
