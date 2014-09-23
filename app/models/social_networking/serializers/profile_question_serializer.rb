module SocialNetworking
  module Serializers
    # Serializes Profile Question models.
    class ProfileQuestionSerializer < Serializer
      def to_serialized
        {
          id: model.id,
          order: model.order,
          allowed_responses: model.allowed_responses,
          question_text: model.question_text,
          deleted: model.deleted
        }
      end
    end
  end
end
