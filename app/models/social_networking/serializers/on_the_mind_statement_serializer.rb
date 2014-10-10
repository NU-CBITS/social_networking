module SocialNetworking
  module Serializers
    # Serializes OnTheMindStatement models.
    class OnTheMindStatementSerializer < Serializer
      def to_serialized
        {
          className: "SocialNetworking::OnTheMindStatement",
          id: model.id,
          createdAt: model.created_at,
          participantId: model.participant_id,
          summary: "said #{ model.description }",
          description: model.description,
          comments: CommentSerializer.from_collection(model.comments)
        }
      end
    end
  end
end
