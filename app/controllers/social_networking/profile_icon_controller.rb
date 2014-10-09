module SocialNetworking
  # Manage profile icons.
  class ProfileIconController < ApplicationController

    skip_before_filter :verify_authenticity_token

    def save
      profile = Profile.find(profile_icon_params[:profile_id])
      profile.icon_name = profile_icon_params[:icon_name]

      if profile.save
        respond_to do |format|
          format.html { render nothing: true, status: :accepted }
          format.js   { render nothing: true, status: :accepted }
          format.json { render nothing: true, status: :accepted }
        end
      end
    end

    private

    def profile_icon_params
      params.require(:profile).permit(:profile_id, :icon_name)
    end
  end
end
