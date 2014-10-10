module SocialNetworking
  module Serializers
    # Serializes Profile models.
    class ProfileSerializer < Serializer
      DEFAULT_ICON = "questionmark"

      def to_serialized
        {
          id: model.id,
          participantId: model.participant_id,
          username: model.user_name,
          latestAction: model.latest_action_at,
          endOfTrial: model.active_membership_end_date,
          iconSrc: ApplicationController.helpers.asset_path(
                     "social_networking/profile_icon_" +
                     (model.icon_name || DEFAULT_ICON) + ".png"
                   )
        }
      end
    end
  end
end
