# frozen_string_literal: true
module SocialNetworking
  module Serializers
    # Serializes Profile models.
    class ProfileSerializer < Serializer
      DEFAULT_ICON = "questionmark"

      def to_serialized
        if model.participant.is_admin
          icon_path = "social_networking/_profile_icon_admin.png"
        else
          icon_path = "social_networking/profile_icon_" +
                      (model.icon_name || DEFAULT_ICON) + ".png"
        end
        {
          id: model.id,
          participantId: model.participant_id,
          username: model.user_name,
          latestAction: model.latest_action_at,
          endOfTrial: model.active_membership_end_date,
          isAdmin: model.participant.is_admin,
          isWoz: woz? && model.participant.is_admin,
          iconSrc: ApplicationController.helpers.asset_path(icon_path)
        }
      end

      private

      def woz?
        model.participant.current_group.try(:arm).try(:woz?)
      end
    end
  end
end
