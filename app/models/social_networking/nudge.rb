module SocialNetworking
  # A form of contact between two Participants.
  class Nudge < ActiveRecord::Base
    belongs_to :initiator, class_name: "Participant"
    belongs_to :recipient, class_name: "Participant"
    has_many :comments, as: "item"

    validates :initiator, :recipient, presence: true

    def self.search(recipient_id)
      if recipient_id
        where(recipient_id: recipient_id).where("created_date < ?", 1.day.ago)
      else
        all
      end
    end
  end
end
