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
      {}
    end

    def description
      "Welcome, #{user_name}!"
    end

    def shared_description
      "Profile Created: #{participant.display_name}"
    end

    def user_name
      participant.display_name
    end
  end
end
