class ChangeColumnDefaultSocialNetworkingProfilesActiveToFalse < ActiveRecord::Migration
  def change
    change_column_default :social_networking_profiles, :active, false
    SocialNetworking::Profile.where(active: nil).each do |p|
      p.update!(active: false)
    end
    change_column_null :social_networking_profiles, :active, false
  end
end
