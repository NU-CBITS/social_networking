module SocialNetworking
  module Serializers
    # Serializes Shared Item models.
    class SharedItemSerializer < Serializer
      def to_serialized
        item = model.item
        label = item.class.to_s.underscore.gsub(/_/m, " ")
        {
          className: "SocialNetworking::SharedItem",
          id: model.id,
          participantId: item.participant_id,
          createdAt: model.created_at,
          description: "#{ item.participant_id } added a #{ label }" \
                       "#{ model.is_public ? ": " + item.description : "" }",
          comments: CommentSerializer.from_collection(model.comments)
        }
      end
    end
  end
end
