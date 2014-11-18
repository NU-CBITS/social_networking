module SocialNetworking
  module Serializers
    # Abstract serializer.
    class Serializer
      attr_reader :model

      def self.from_collection(collection)
        collection.map { |i| new(i).to_serialized }.compact
      end

      def initialize(model)
        @model = model
      end
    end
  end
end
