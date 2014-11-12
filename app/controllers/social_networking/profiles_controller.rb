module SocialNetworking
  # Manage Participants.
  class ProfilesController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    def index
      render json: Serializers::ProfileSerializer.from_collection(Profile.all)
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
      profile = Profile.find(profile_params[:id])
      profile.update(icon_name: profile_params[:icon_name])

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
