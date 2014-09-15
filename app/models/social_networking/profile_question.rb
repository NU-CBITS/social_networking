module SocialNetworking
  # A question that is posed to participants when a profile is being created or updated.
  class ProfileQuestion < ActiveRecord::Base
    belongs_to :group

    has_many :social_networking_profile_answers, :class_name => 'SocialNetworking::ProfileAnswer'
  end
end
