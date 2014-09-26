module SocialNetworking
  module Serializers
    # Serializes Goal models.
    class GoalSerializer < Serializer
      def to_serialized
        {
          className: "SocialNetworking::Goal",
          id: model.id,
          participantId: model.participant_id,
          description: model.description,
          isCompleted: model.is_completed,
          isDeleted: model.is_deleted,
          dueOn: model.due_on,
          comments: CommentSerializer.from_collection(model.comments)
        }
      end
    end
  end
end
