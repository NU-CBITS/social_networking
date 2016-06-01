# frozen_string_literal: true
module SocialNetworking
  # A question that is posed to participants when a profile is being created or
  # updated.
  class ProfileQuestion < ActiveRecord::Base
    belongs_to :group,
               class_name: "ThinkFeelDoEngine::Group",
               foreign_key: :group_id

    has_many :profile_answers,
             class_name: "SocialNetworking::ProfileAnswer",
             foreign_key: :social_networking_profile_question_id,
             dependent: :destroy
  end
end
