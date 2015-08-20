require "spec_helper"

module SocialNetworking
  module Serializers
    RSpec.describe OnTheMindStatementSerializer do
      let(:participant) { instance_double(Participant, is_admin: true) }
      let(:on_the_mind) do
        instance_double(
          OnTheMindStatement,
          id: 1,
          created_at: Time.now,
          participant_id: 1,
          description: "",
          comments: [],
          likes: []
        )
      end
      let(:serialized_comment) do
        OnTheMindStatementSerializer
          .new(on_the_mind)
          .to_serialized
      end

      describe ".to_serialized" do
        it "includes necessary properties" do
          allow(on_the_mind).to receive(:participant) { participant }

          expect(serialized_comment)
            .to include(
              :className,
              :id,
              :createdAt,
              :createdAtRaw,
              :participantId,
              :isAdmin,
              :summary,
              :description,
              :comments,
              :likes
            )
        end
      end
    end
  end
end
