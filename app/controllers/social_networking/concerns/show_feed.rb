module SocialNetworking
  module Concerns
    # Collects data for feed/profiles page.
    module ShowFeed
      def feed_data_for(participant, context)
        @participant = participant
        @context = context

        {
          action_items: action_items,
          feed_items: feed_items,
          member_profiles: member_profiles,
          profile_path: @context.social_networking_profile_path
        }
      end

      private

      def action_items
        items = ActionItem.for(@participant)
        current_profile = Profile.find_by_participant_id(@participant.id)
        if !current_profile || !current_profile.icon_name
          items.unshift(
            link: @context.social_networking_profile_path,
            label: "Create a Profile"
          )
        end

        items
      end

      def feed_items
        Serializers::OnTheMindStatementSerializer
          .from_collection(
            OnTheMindStatement.joins(participant: [{ memberships: :group }])
              .where(groups: { id: @participant.active_group.id })
              .includes(:comments, :likes)) +
          Serializers::NudgeSerializer
            .from_collection(
              Nudge.joins(initiator: [{ memberships: :group }])
                .where(groups: { id: @participant.active_group.id })
                .includes(:comments)) +
          Serializers::SharedItemSerializer
            .from_collection(group_shared_items)
      end

      def group_shared_items
        SharedItem
          .includes(:item, :comments, :likes)
          .all
          .select do |shared_item|
            shared_item.item.try(:participant).try(:active_group).try(:id) ==
              @participant.active_group.id
          end
      end

      def member_profiles
        return if @participant.active_group.nil?
        group_participants =
          @participant.active_group.active_participants

        Serializers::ProfileSerializer.from_collection(
          Profile.where(participant_id: group_participants.pluck(:id)))
      end
    end
  end
end
