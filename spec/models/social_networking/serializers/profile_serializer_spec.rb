# frozen_string_literal: true
require "spec_helper"

module SocialNetworking
  module Serializers
    RSpec.describe ProfileSerializer do
      let(:participant) do
        instance_double(
          Participant,
          display_name: "foo"
        )
      end

      let(:profile) do
        instance_double(
          Profile,
          id: 1,
          participant_id: 1,
          user_name: "bar",
          latest_action_at: Time.current,
          active_membership_end_date: Time.zone.today
        )
      end

      let(:serialized_profile) do
        ProfileSerializer
          .new(profile)
          .to_serialized
      end

      describe ".to_serialized" do
        before do
          allow(profile)
            .to receive(:participant) { participant }
        end

        describe "when participant is an admin" do
          before do
            allow(participant)
              .to receive(:is_admin) { true }
          end

          describe "when participant doesn't have an active group" do
            before do
              allow(participant)
                .to receive(:current_group)
            end

            it "includes necessary properties" do
              expect(serialized_profile)
                .to include(
                  :id,
                  :participantId,
                  :username,
                  :latestAction,
                  :endOfTrial,
                  :isAdmin,
                  :isWoz,
                  :iconSrc
                )
            end
          end
        end
      end
    end
  end
end
