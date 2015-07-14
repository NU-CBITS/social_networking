module SocialNetworking
  module Serializers
    # Serializes OnTheMindStatement models.
    class OnTheMindStatementSerializer < Serializer
      def to_serialized
        {
          className: "SocialNetworking::OnTheMindStatement",
          id: model.id,
          createdAt: model.created_at,
          createdAtRaw: model.created_at.to_i,
          participantId: model.participant_id,
          isAdmin: model.participant.is_admin,
          summary: "said #{ model.description }",
          description: model.description,
          comments: CommentSerializer.from_collection(model.comments),
          likes: LikeSerializer.from_collection(model.likes)
        }
      end
    end
  end
end
