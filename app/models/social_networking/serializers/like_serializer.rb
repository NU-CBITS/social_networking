module SocialNetworking
  module Serializers
    # Serializes Like models.
    class LikeSerializer < Serializer
      def to_serialized
        {
          id: model.id,
          participantId: model.participant_id,
          participantDisplayName: model.participant.display_name,
          itemType: model.item_type,
          itemId: model.item_id
        }
      end
    end
  end
end
