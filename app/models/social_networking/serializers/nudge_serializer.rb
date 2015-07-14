module SocialNetworking
  module Serializers
    # Serializes Nudge models.
    class NudgeSerializer < Serializer
      def to_serialized
        recipient_profile = Profile.find_by_participant_id(model.recipient_id)

        {
          className: "SocialNetworking::Nudge",
          id: model.id,
          participantId: model.initiator_id,
          isAdmin: model.initiator.is_admin,
          createdAt: model.created_at,
          createdAtRaw: model.created_at.to_i,
          initiatorId: model.initiator_id,
          recipientId: model.recipient_id,
          summary: "nudged #{ recipient_profile.user_name }",
          description: "nudge",
          comments: CommentSerializer.from_collection(model.comments)
        }
      end
    end
  end
end
