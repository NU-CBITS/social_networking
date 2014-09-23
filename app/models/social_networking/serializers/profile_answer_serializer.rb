module SocialNetworking
  module Serializers
    # Serializes Profile Answer models.
    class ProfileAnswerSerializer < Serializer
      def to_serialized
        {
          id: model.id,
          profile_id: model.social_networking_profile_id,
          profile_question_id: model.social_networking_profile_question_id,
          order: model.order,
          answer: model.answer_text
        }
      end
    end
  end
end
