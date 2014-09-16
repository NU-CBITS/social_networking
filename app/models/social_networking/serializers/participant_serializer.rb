module SocialNetworking
  module Serializers
    # Serializes Participant models.
    class ParticipantSerializer < Serializer
      def to_serialized
        {
          id: model.id,
          username: model.email,
          lastLogin: model.last_sign_in_at,
          endOfTrial: model.active_membership_end_date
        }
      end
    end
  end
end
