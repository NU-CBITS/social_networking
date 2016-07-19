# frozen_string_literal: true
require "spec_helper"

module SocialNetworking
  module Reports
    RSpec.describe ToolShare do
      fixtures :all

      def data
        @data ||= ToolShare.all
      end

      describe ".all" do
        context "when no items shared" do
          it "returns an empty array" do
            SocialNetworking::SharedItem.destroy_all
            expect(data).to be_empty
          end
        end

        context "when items shared" do
          it "returns accurate summaries" do
            participant = participants(:participant1)
            otms = SocialNetworking::OnTheMindStatement
                   .create!(participant_id: participants(:participant1).id,
                            description: "otms description")
            shared_item = SharedItem.create!(item: otms)
            expect(data).to include(
              participant_id: participant.study_id,
              item_type: shared_item.item_type,
              item_id: shared_item.item_id,
              shared_at: shared_item.created_at.iso8601,
              action_type: shared_item.action_type,
              item_label: shared_item.item_label
            )
          end
        end
      end
    end
  end
end
