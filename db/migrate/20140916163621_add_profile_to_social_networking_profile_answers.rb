class AddProfileToSocialNetworkingProfileAnswers < ActiveRecord::Migration
  def change
    add_reference :social_networking_profile_answers, :social_networking_profile, index: false
  end
end
