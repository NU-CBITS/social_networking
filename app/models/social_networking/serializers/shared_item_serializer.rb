module SocialNetworking
  module Serializers
    # Serializes Shared Item models.
    class SharedItemSerializer < Serializer
      def to_serialized
        item = model.item
        path = item.class.to_s.pluralize.underscore
        label = item.class.to_s.underscore.gsub(/_/m, " ")

        {
          className: "SocialNetworking::SharedItem",
          id: model.id,
          participantId: item.participant_id,
          createdAt: model.created_at,
          templatePath: "/social_networking/templates/#{ path }",
          isPublic: model.is_public,
          data: item.to_serialized,
          summary: "#{ item.participant_id } added a #{ label }" \
                   "#{ model.is_public ? ": " + item.description : "" }",
          description: item.description,
          comments: CommentSerializer.from_collection(model.comments)
        }
      end
    end
  end
end
