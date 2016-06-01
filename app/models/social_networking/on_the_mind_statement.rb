# frozen_string_literal: true
module SocialNetworking
  # A statement by a Participant to be shared with the Group.
  class OnTheMindStatement < ActiveRecord::Base
    belongs_to :participant
    has_many :comments, as: "item", dependent: :destroy
    has_many :likes, as: "item", dependent: :destroy

    validates :participant, :description, presence: true

    scope :for_today, lambda {
      where(
        "created_at <= ? AND created_at >= ?",
        Time.zone.today.end_of_day,
        Time.zone.today.beginning_of_day
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
