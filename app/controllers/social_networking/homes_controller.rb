module SocialNetworking
  # Provide Participant home page tools.
  class HomesController < ApplicationController
    def show
      @action_items = ActionItem.for(current_participant)
      @feed_items = (
        Serializers::OnTheMindStatementSerializer
          .from_collection(OnTheMindStatement.includes(:comments, :likes)) +
        Serializers::NudgeSerializer
          .from_collection(Nudge.includes(:comments)) +
        Serializers::SharedItemSerializer
          .from_collection(SharedItem.includes(:item, :comments, :likes))
      )
      @member_profiles = Serializers::ProfileSerializer
                         .from_collection(Profile.includes(:participant))
    end
  end
end
