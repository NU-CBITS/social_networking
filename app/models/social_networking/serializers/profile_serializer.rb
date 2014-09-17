module SocialNetworking
  module Serializers
    # Serializes Profile models.
    class ProfileSerializer < Serializer
      def to_serialized
        {
          id: model.id,
          participant_id: model.participant_id,
          username: model.user_name,
          lastLogin: model.last_sign_in,
          endOfTrial: model.active_membership_end_date
        }
      end
    end
  end
end
