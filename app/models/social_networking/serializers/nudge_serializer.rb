module SocialNetworking
  module Serializers
    # Serializes Nudge models.
    class NudgeSerializer < Serializer
      def to_serialized
        {
          className: "SocialNetworking::Nudge",
          id: model.id,
          createdAt: model.created_at,
          initiatorId: model.initiator_id,
          recipientId: model.recipient_id,
          description: "#{ model.initiator_id } nudged #{ model.recipient_id }",
          comments: CommentSerializer.from_collection(model.comments)
        }
      end
    end
  end
end
