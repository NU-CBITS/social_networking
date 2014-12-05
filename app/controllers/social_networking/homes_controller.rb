module SocialNetworking
  # Provide Participant home page tools.
  class HomesController < ApplicationController
    def show
      @action_items = ActionItem.for(current_participant)
      current_profile = Profile.find_by_participant_id(current_participant.id)
      if !current_profile || !current_profile.icon_name
        @action_items.unshift(
          link: social_networking_profile_path,
          label: "Create a Profile"
        )
      end
      @feed_items = (
        Serializers::OnTheMindStatementSerializer
          .from_collection(OnTheMindStatement.includes(:comments, :likes)) +
        Serializers::NudgeSerializer
          .from_collection(Nudge.includes(:comments)) +
        Serializers::SharedItemSerializer
          .from_collection(SharedItem.includes(:item, :comments, :likes))
      )
      in_group_participants = current_participant.active_group.active_participants
      @member_profiles = Serializers::ProfileSerializer
                         .from_collection(Profile.where(participant_id: in_group_participants.pluck(:id)))
    end
  end
end
