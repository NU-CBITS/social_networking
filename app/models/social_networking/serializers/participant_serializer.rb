# frozen_string_literal: true
module SocialNetworking
  module Serializers
    # Serializes Participant models.
    class ParticipantSerializer < Serializer
      def to_serialized
        {
          id: model.id,
          username: model.email,
          latestAction: model.latest_action_at,
          endOfTrial: model.active_membership_end_date
        }
      end
    end
  end
end
