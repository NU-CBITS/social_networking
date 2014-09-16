module SocialNetworking
  module Serializers
    # Serializes OnTheMindStatement models.
    class OnTheMindStatementSerializer < Serializer
      def to_serialized
        {
          id: model.id,
          participantId: model.participant_id,
          description: model.description
        }
      end
    end
  end
end
