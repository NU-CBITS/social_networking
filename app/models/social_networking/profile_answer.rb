module SocialNetworking
  # A question that is posed to participants when a profile is being created or updated.
  class ProfileAnswer < ActiveRecord::Base
    belongs_to :social_networking_profile, :class_name => 'SocialNetworking::Profile'
    has_one :social_networking_profile_question, :class_name => 'SocialNetworking::ProfileQuestion'

    validates :social_networking_profile, :social_networking_profile_question, presence: true
  end
end
