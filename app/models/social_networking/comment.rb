module SocialNetworking
  # A comment written by a Participant and attached to a piece of content.
  class Comment < ActiveRecord::Base
    belongs_to :participant
    belongs_to :item, polymorphic: true

    validates :participant, :item, :text, presence: true

    scope :for_today, lambda {
      where(
          "created_at <= ? AND created_at >= ?",
          Date.today.end_of_day,
          Date.today.beginning_of_day)
    }

    scope :for_week, lambda {
      where("created_at >= ?", Time.current.advance(days: -7).beginning_of_day)
    }
  end
end
