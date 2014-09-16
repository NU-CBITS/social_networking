module SocialNetworking
  module Serializers
    # Serializes Nudge models.
    class NudgeSerializer < Serializer
      def to_serialized
        {
          id: model.id,
          initiatorId: model.initiator_id,
          recipientId: model.recipient_id
        }
      end
    end
  end
end
