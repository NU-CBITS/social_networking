module SocialNetworking
  module Concerns
    # Collects data for feed/profiles page.
    module ShowFeed
      def feed_data_for(participant, context)
        @participant = participant
        @context = context

        {
          action_items: action_items,
          feed_items: [],
          member_profiles: member_profiles,
          profile_path: @context.social_networking_profile_path
        }
      end

      private

      def active_group
        @participant.active_group
      end

      def action_items
        items = ActionItem.for(@participant)
        current_profile = Profile.find_by_participant_id(@participant.id)
        unless current_profile.try(:started?)
          items.unshift(
            link: @context.social_networking_profile_path,
            label: "Create a Profile"
          )
        end

        items
      end

      def member_profiles
        return unless active_group
        Serializers::ProfileSerializer.from_collection(
          Profile.where(
            participant_id: active_group.active_participants.pluck(:id)))
      end
    end
  end
end
