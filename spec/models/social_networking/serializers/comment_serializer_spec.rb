require "spec_helper"

module SocialNetworking
  module Serializers
    RSpec.describe CommentSerializer, type: :model do
      fixtures(:"social_networking/comments")

      let(:comment) { social_networking_comments(:participant1_comment_1) }

      it ".to_serialized" do
        expect(Serializers::CommentSerializer.new(comment).to_serialized)
          .to include(:createdAt)
      end
    end
  end
end
