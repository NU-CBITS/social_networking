# frozen_string_literal: true
require "spec_helper"

module SocialNetworking
  module Concerns
    # Collects data for feed/profiles page.
    describe ShowFeed do
      fixtures(:all)
      let(:terminated_participant) { participants(:participant1) }
      let(:participant1) { participants(:participant1) }
      let(:participant2) { participants(:participant2) }
      let(:participant3) { participants(:participant3) }
      let(:show_feed_extension) { Class.new { extend ShowFeed } }
      let(:active_record_results) do
        double("active_record_results", pluck: nil)
      end
      let(:array_results) { double("participant_array") }

      it "should exclude terminated participants from profile list" do
        expect(participant1)
          .to receive(:active_group) do
          double("active_record_results",
                 active_participants: active_record_results)
        end
        allow(active_record_results).to receive(:to_a) { array_results }
        allow(array_results).to receive(:delete_if) { [participant1] }
        allow(participant2)
          .to receive(:active_group)
          .exactly(8).times do
          double("result", active_participants: active_record_results)
        end
        allow(participant1)
          .to receive(:active_group)
          .exactly(8).times do
          double("result", active_participants: active_record_results)
        end

        show_feed_extension
          .feed_data_for(
            participant1,
            double("context",
                   social_networking_profile_path: "some_path")
          )
      end
    end
  end
end
