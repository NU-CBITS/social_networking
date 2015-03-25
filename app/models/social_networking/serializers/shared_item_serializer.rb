module SocialNetworking
  module Serializers
    # Serializes Shared Item models.
    class SharedItemSerializer < Serializer
      def to_serialized
        item = model.item

        return nil if item.nil?

        path = item.class.to_s.pluralize.underscore
        label = model.item_label ||
                ActiveSupport::Inflector.demodulize(item.class).humanize
        {
          className: "SocialNetworking::SharedItem",
          id: model.id,
          participantId: item.participant_id,
          createdAt: model.created_at,
          createdAtRaw: model.created_at.to_i,
          templatePath: "/social_networking/templates/#{ path }",
          isPublic: model.is_public,
          data: item.to_serialized,
          summary: "#{ model.action_type } #{ indefinite_articlerize(label) }" \
                   "#{ model.is_public ? ": " + item.description : "" }",
          description: item.description,
          comments: CommentSerializer.from_collection(model.comments),
          likes: LikeSerializer.from_collection(model.likes)
        }
      end

      private

      # lifted from http://stackoverflow.com/questions/5381738/rails-article-helper-a-or-an
      def indefinite_articlerize(word)
        "a#{ %w(a e i o u).include?(word[0].downcase) ? "n" : "" } #{ word }"
      end
    end
  end
end
