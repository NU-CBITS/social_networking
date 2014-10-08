module SocialNetworking
  # Manage profile icons.
  class ProfileIconController < ApplicationController

    def save
      profile = Profiles.find(profile_icon_params[:profile_id])
      profile.icon_name = profile_icon_params[:icon_name]
      profile.save
    end

    private

    def profile_icon_params
      params.permit(:profile_id, :icon_name)
    end
  end
end
