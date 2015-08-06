require "spec_helper"

module SocialNetworking
  module Serializers
    RSpec.describe LikeSerializer, type: :model do
      fixtures(:"social_networking/likes")

      let(:comment) { social_networking_likes(:participant1_like_1) }

      it ".to_serialized" do
        expect(Serializers::LikeSerializer.new(comment).to_serialized)
          .to include(:createdAt)
      end
    end
  end
end
