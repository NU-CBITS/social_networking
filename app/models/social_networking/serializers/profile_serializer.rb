module SocialNetworking
  module Serializers
    # Serializes Profile models.
    class ProfileSerializer < Serializer
      def to_serialized
        {
          id: model.id,
          participant_id: model.participant_id,
          username: model.user_name,
          latestAction: model.latest_action_at,
          endOfTrial: model.active_membership_end_date
        }
      end
    end
  end
end
