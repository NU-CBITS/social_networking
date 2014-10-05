module SocialNetworking
  # Provide Participant home page tools.
  class HomesController < ApplicationController
    def show
      @action_items = ActionItem.for(current_participant)
      @feed_items = (
        Serializers::OnTheMindStatementSerializer
          .from_collection(OnTheMindStatement.includes(:comments)) +
        Serializers::GoalSerializer.from_collection(Goal.includes(:comments)) +
        Serializers::NudgeSerializer
          .from_collection(Nudge.includes(:comments)) +
        Serializers::SharedItemSerializer
          .from_collection(SharedItem.includes(:item, :comments))
      )
      @member_profiles = []
    end
  end
end
