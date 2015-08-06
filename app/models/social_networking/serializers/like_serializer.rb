module SocialNetworking
  module Serializers
    # Serializes Like models.
    class LikeSerializer < Serializer
      def to_serialized
        {
          createdAt: model.created_at,
          id: model.id,
          participantId: model.participant_id,
          participantDisplayName: model.participant.display_name,
          isAdmin: model.participant.is_admin,
          itemType: model.item_type,
          itemId: model.item_id
        }
      end
    end
  end
end
