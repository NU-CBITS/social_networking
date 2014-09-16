module SocialNetworking
  module Serializers
    # Serializes Goal models.
    class GoalSerializer < Serializer
      def to_serialized
        {
          id: model.id,
          participantId: model.participant_id,
          description: model.description,
          isCompleted: model.is_completed,
          isDeleted: model.is_deleted,
          dueOn: model.due_on
        }
      end
    end
  end
end
