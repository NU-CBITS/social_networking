module SocialNetworking
  module Serializers
    # Serializes Comment models.
    class CommentSerializer < Serializer
      def to_serialized
        {
          id: model.id,
          participantId: model.participant_id,
          text: model.text,
          itemType: model.item_type,
          itemId: model.item_id
        }
      end
    end
  end
end
