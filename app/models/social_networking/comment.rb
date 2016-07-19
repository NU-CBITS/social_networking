# frozen_string_literal: true
module SocialNetworking
  # A comment written by a Participant and attached to a piece of content.
  class Comment < ActiveRecord::Base
    belongs_to :participant
    belongs_to :item, polymorphic: true

    validates :participant, :item, :text, presence: true

    scope :for_today, lambda {
      where(arel_table[:created_at]
                .gteq(Time.zone.today.beginning_of_day)
                .and(arel_table[:created_at].lteq(Time.zone.today.end_of_day)))
    }

    scope :for_week, lambda {
      where(arel_table[:created_at]
                 .gteq(Time.current.advance(days: -7).beginning_of_day))
    }

    def item_description
      case item_type
      when SocialNetworking::OnTheMindStatement.to_s
        Shareable.new(item).description
      when SocialNetworking::SharedItem.to_s
        if item
          Shareable.new(item.item).description
        else
          Shareable.new(nil).description
        end
      end
    end
  end
end
