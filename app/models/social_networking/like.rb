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
            where(arel_table[:created_at]
                    .gteq(Date.today.beginning_of_day)
                    .and(arel_table[:created_at].lteq(Date.today.end_of_day)))
          }

    scope :for_week,
          lambda {
            where(arel_table[:created_at]
                    .gteq(Time.current.advance(days: -7).beginning_of_day))
          }

    def item_description
      case item_type
      when "SocialNetworking::OnTheMindStatement"
        "#{SocialNetworking::
            OnTheMindStatement.find(item_id).description}"
      when "SocialNetworking::SharedItem"
        shared_item_description
      else
        "Unknown Item Type(to reporting tool), Item ID:#{item_id}"
      end
    end

    private

    def shared_item_description
      if item
        case item.item_type
        when "Activity"
          activity = Activity.find(item.item_id)
          "#{activity.participant.study_id}:"\
      " #{activity.activity_type.title}"
        when "SocialNetworking::Profile"
          "ProfileCreation: #{item.participant.study_id}"
        when "SocialNetworking::Goal"
          goal = SocialNetworking::Goal.find(item.item_id)
          "#{goal.participant.study_id}: #{goal.description}"
        when "Thought"
          thought = Thought.find(item.item_id)
          "#{thought.participant.study_id}: #{thought.description}"
        else
          "Unknown SharedItem Type (reporting), Item ID:#{item_id}"
        end
      else
        "Like was for an unknown item (for reporting tool)."
      end
    end
  end
end
