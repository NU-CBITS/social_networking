require "spec_helper"

module SocialNetworking
  module Serializers
    RSpec.describe CommentSerializer do
      let(:participant) { instance_double(Participant, is_admin: true) }
      let(:comment) do
        instance_double(
          Comment,
          id: 1,
          created_at: Time.zone.now,
          item_id: 1,
          item_type: "",
          participant_id: 1,
          text: ""
        )
      end
      let(:serialized_comment) do
        CommentSerializer
          .new(comment)
          .to_serialized
      end

      describe ".to_serialized" do
        it "includes necessary properties" do
          allow(comment).to receive(:participant) { participant }

          expect(serialized_comment)
            .to include(
              :createdAt,
              :id,
              :isAdmin,
              :itemId,
              :itemType,
              :participantId,
              :text
            )
        end
      end
    end
  end
end
