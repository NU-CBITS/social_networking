# frozen_string_literal: true
module SocialNetworking
  # A question that is posed to participants when a profile is being created or
  # updated.
  class ProfileAnswer < ActiveRecord::Base
    belongs_to :profile,
               class_name: "SocialNetworking::Profile",
               foreign_key: :social_networking_profile_id
    belongs_to :profile_question,
               class_name: "SocialNetworking::ProfileQuestion",
               foreign_key: :social_networking_profile_question_id

    validates :profile, :profile_question, presence: true
    validates :social_networking_profile_question_id, uniqueness: {
      scope: :social_networking_profile_id, message: "has already been answered"
    }
  end
end
