require "spec_helper"

module SocialNetworking
  module Reports
    RSpec.describe Comment do
      fixtures :all

      def data
        @data ||= SocialNetworking::Reports::Comment.all
      end

      describe ".all" do
        context "when no comments made" do
          it "returns an empty array" do
            SocialNetworking::Comment.destroy_all
            expect(data).to be_empty
          end
        end

        context "when comments made" do
          it "returns accurate summaries" do
            expect(data.count).to eq 1
            participant = participants(:participant1)
            comment = SocialNetworking::Comment.first
            item = (comment.item.try(:item) || comment.item)
            expect(data).to include(
              participant_id: participant.study_id,
              occurred_at: comment.created_at,
              item_type: item.class.to_s,
              text: comment.text
            )
          end
        end
      end
    end
  end
end
