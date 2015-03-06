module SocialNetworking
  # A form of contact between two Participants.
  class Nudge < ActiveRecord::Base
    belongs_to :initiator,
               class_name: "Participant",
               foreign_key: "initiator_id"
    belongs_to :recipient, class_name: "Participant"
    has_many :comments, as: "item"

    accepts_nested_attributes_for :recipient

    alias_attribute :participant_id, :initiator_id

    validates :initiator, :recipient, presence: true

    def self.search(recipient_id)
      if recipient_id
        select(:initiator_id)
          .where(recipient_id: recipient_id)
          .where("created_at > ?", 1.day.ago)
          .group(:initiator_id)
      else
        all
      end
    end

    scope :for_today, lambda {
      where(
          "created_at <= ? AND created_at >= ?",
          Date.today.end_of_day,
          Date.today.beginning_of_day
      )
    }

    scope :for_week, lambda {
      where("created_at >= ?", Time.current.advance(days: -7).beginning_of_day)
    }
  end
end
