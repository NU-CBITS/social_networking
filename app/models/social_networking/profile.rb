module SocialNetworking
  # A set of data representing a Social Profile belonging to a Participant.
  class Profile < ActiveRecord::Base
    belongs_to :participant
    has_many :profile_answers,
             class_name: "SocialNetworking::ProfileAnswer",
             foreign_key: :social_networking_profile_id,
             dependent: :destroy

    validates :participant, presence: true

    delegate :latest_action_at, :active_membership_end_date,
             to: :participant

    def user_name
      participant.email
    end
  end
end
