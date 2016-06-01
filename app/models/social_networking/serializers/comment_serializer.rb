# frozen_string_literal: true
module SocialNetworking
  module Serializers
    # Serializes Comment models.
    class CommentSerializer < Serializer
      def to_serialized
        {
          createdAt: model.created_at,
          id: model.id,
          participantId: model.participant_id,
          isAdmin: model.participant.is_admin,
          text: model.text,
          itemType: model.item_type,
          itemId: model.item_id
        }
      end
    end
  end
end
