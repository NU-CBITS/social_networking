module SocialNetworking
  module Serializers
    # Serializes Profile models.
    class ProfileSerializer < Serializer
      def to_serialized
        {
          id: model.id,
          username: model.participant.email,
          lastLogin: model.participant.last_sign_in_at,
          endOfTrial: model.participant.active_membership_end_date
        }
      end
    end
  end
end
