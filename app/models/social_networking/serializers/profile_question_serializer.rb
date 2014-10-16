module SocialNetworking
  module Serializers
    # Serializes Profile Question models.
    class ProfileQuestionSerializer < Serializer
      def to_serialized
        {
          id: model.id,
          question_text: model.question_text
        }
      end
    end
  end
end
