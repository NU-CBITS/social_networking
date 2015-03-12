require "spec_helper"

module SocialNetworking
  module Reports
    RSpec.describe Nudge do
      fixtures :all

      def data
        @data ||= SocialNetworking::Reports::Nudge.all
      end

      describe ".all" do
        context "when no nudges performed" do
          it "returns an empty array" do
            SocialNetworking::Nudge.destroy_all
            expect(data).to be_empty
          end
        end

        context "when nudges performed" do
          it "returns accurate summaries" do
            participant = participants(:participant1)
            nudge = SocialNetworking::Nudge.first
            expect(data.count).to eq 4
            expect(data).to include(
              participant_id: participant.study_id,
              occurred_at: nudge.created_at,
              recipient_id: nudge.recipient.study_id
            )
          end
        end
      end
    end
  end
end
