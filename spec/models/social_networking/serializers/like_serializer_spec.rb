require "spec_helper"

module SocialNetworking
  module Serializers
    RSpec.describe LikeSerializer do
      let(:participant) do
        instance_double(
          Participant,
          display_name: "foo",
          is_admin: true)
      end
      let(:like) do
        instance_double(
          Like,
          created_at: Time.zone.now,
          id: 1,
          item_id: 1,
          item_type: "foo",
          participant_id: 1
        )
      end
      let(:serialized_like) do
        LikeSerializer
          .new(like)
          .to_serialized
      end

      describe ".to_serialized" do
        it "includes necessary properties" do
          allow(like).to receive(:participant) { participant }

          expect(serialized_like)
            .to include(
              :createdAt,
              :id,
              :isAdmin,
              :itemType,
              :itemId,
              :participantId,
              :participantDisplayName
            )
        end
      end
    end
  end
end
