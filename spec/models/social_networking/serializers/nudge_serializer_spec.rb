require "spec_helper"

module SocialNetworking
  module Serializers
    RSpec.describe NudgeSerializer do
      let(:initiator) { instance_double(Participant, is_admin: true) }
      let(:profile) { instance_double(Profile) }
      let(:nudge) do
        instance_double(
          Nudge,
          id: 1,
          initiator_id: 1,
          created_at: Time.now,
          recipient_id: 1,
          comments: []
        )
      end
      let(:serialized_nudge) do
        NudgeSerializer
          .new(nudge)
          .to_serialized
      end

      describe ".to_serialized" do
        it "includes necessary properties" do
          allow(nudge).to receive(:initiator) { initiator }
          allow(Profile).to receive(:find_by_participant_id) { profile }
          allow(profile).to receive(:user_name)

          expect(serialized_nudge)
            .to include(
              :className,
              :id,
              :participantId,
              :isAdmin,
              :createdAt,
              :createdAtRaw,
              :initiatorId,
              :recipientId,
              :summary,
              :description,
              :comments
            )
        end
      end
    end
  end
end
