module SocialNetworking
  # A set of data representing a Social Profile belonging to a Participant.
  class Profile < ActiveRecord::Base
    ACTION_TYPES = %w( created completed )
    Actions = Struct.new(*ACTION_TYPES.map(&:to_sym)).new(*ACTION_TYPES)

    belongs_to :participant
    has_many :profile_answers,
             class_name: "SocialNetworking::ProfileAnswer",
             foreign_key: :social_networking_profile_id,
             dependent: :destroy
    has_many :comments, as: "item"
    has_many :likes, as: "item"

    validates :participant, presence: true

    delegate :latest_action_at, :active_membership_end_date,
             to: :participant

    def to_serialized
      {
        participantId: participant_id,
        description: "New profile"
      }
    end

    def description
      "Welcome, #{participant.email}!"
    end

    def user_name
      participant.email
    end
  end
end
