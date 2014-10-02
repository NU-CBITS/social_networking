module SocialNetworking
  # Provide Participant home page tools.
  class HomesController < ApplicationController
    def show
      @action_items = ActionItem.for(current_participant)
      @feed_items = (
        Serializers::OnTheMindStatementSerializer
          .from_collection(OnTheMindStatement.all) +
        Serializers::GoalSerializer.from_collection(Goal.all) +
        Serializers::NudgeSerializer.from_collection(Nudge.all) +
        Serializers::SharedItemSerializer.from_collection(SharedItem.all)
      )
      @member_profiles = []
    end
  end
end
