module SocialNetworking
  # A form of contact between two Participants.
  class Nudge < ActiveRecord::Base
    belongs_to :initiator, class_name: "Participant"
    belongs_to :recipient, class_name: "Participant"

    validates :initiator, :recipient, presence: true
  end
end
