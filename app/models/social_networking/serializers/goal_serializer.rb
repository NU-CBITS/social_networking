# frozen_string_literal: true
module SocialNetworking
  module Serializers
    # Serializes Goal models.
    class GoalSerializer < Serializer
      def to_serialized
        {
          className: "SocialNetworking::Goal",
          id: model.id,
          createdAt: model.created_at,
          participantId: model.participant_id,
          isAdmin: model.participant.is_admin,
          summary: "#{model.participant_id} set the goal " \
                   "#{model.description}",
          description: model.description,
          isCompleted: model.is_completed,
          isDeleted: model.is_deleted,
          dueOn: model.due_on ? model.due_on.to_s(:participant_date) : "",
          comments: CommentSerializer.from_collection(model.comments)
        }
      end
    end
  end
end
