module SocialNetworking
  # A set of data representing a Social Profile belonging to a Participant.
  class Profile < ActiveRecord::Base
    attr_accessor :user_name, :last_sign_in, :active_membership_end_date

    belongs_to :participant
    has_many :profile_answers,
             class_name: "SocialNetworking::ProfileAnswer",
             foreign_key: :social_networking_profile_id,
             dependent: :destroy

    validates :participant, presence: true
  end
end
