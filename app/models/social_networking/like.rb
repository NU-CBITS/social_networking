# frozen_string_literal: true
module SocialNetworking
  # A sign of approval of a piece of content by a Participant.
  class Like < ActiveRecord::Base
    belongs_to :participant
    belongs_to :item, polymorphic: true

    validates :participant, :item, presence: true
    # a Participant may only Like an item once
    validates :item_id, uniqueness: { scope: [:item_type, :participant_id] }

    scope :for_today,
          lambda {
            where(
              arel_table[:created_at]
              .gteq(Time.zone.today.beginning_of_day)
              .and(arel_table[:created_at].lteq(Time.zone.today.end_of_day))
            )
          }

    scope :for_week,
          lambda {
            where(arel_table[:created_at]
                    .gteq(Time.current.advance(days: -7).beginning_of_day))
          }

    def item_description
      case item_type
      when "SocialNetworking::OnTheMindStatement"
        Shareable.new(item).description
      when "SocialNetworking::SharedItem"
        if item
          Shareable.new(item.item).description
        else
          Shareable.new(nil).description
        end
      end
    end
  end
end
