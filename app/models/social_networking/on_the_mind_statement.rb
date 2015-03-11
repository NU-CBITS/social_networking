module SocialNetworking
  # A statement by a Participant to be shared with the Group.
  class OnTheMindStatement < ActiveRecord::Base
    belongs_to :participant
    has_many :comments, as: "item"
    has_many :likes, as: "item"

    validates :participant, :description, presence: true

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

    def shared_description
      description
    end
  end
end
