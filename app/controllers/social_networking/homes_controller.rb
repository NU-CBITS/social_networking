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
        .from_collection(
          OnTheMindStatement.joins(participant: [{ memberships: :group }])
            .where(groups: { id: current_participant.active_group.id })
            .includes(:comments, :likes)) +
        Serializers::NudgeSerializer
          .from_collection(
            Nudge.joins(initiator: [{ memberships: :group }])
              .where(groups: { id: current_participant.active_group.id })
              .includes(:comments)) +
        Serializers::SharedItemSerializer
          .from_collection(group_shared_items(current_participant)))
      set_member_profiles
    end

    private

    def group_shared_items(current_participant)
      SharedItem
        .includes(:item, :comments, :likes)
        .all
        .select do |shared_item|
          shared_item.item.try(:participant).try(:active_group).try(:id) ==
            current_participant.active_group.id
        end
    end

    def set_member_profiles
      return if current_participant.active_group.nil?
      group_participants =
        current_participant.active_group.active_participants
      @member_profiles = Serializers::ProfileSerializer.from_collection(
        Profile.where(participant_id: group_participants.pluck(:id)))
    end
  end
end
