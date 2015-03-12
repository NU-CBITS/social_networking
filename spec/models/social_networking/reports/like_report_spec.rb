require "spec_helper"

module SocialNetworking
  module Reports
    RSpec.describe Like do
      fixtures :all

      def data
        @data ||= SocialNetworking::Reports::Like.all
      end

      describe ".all" do
        context "when no likes performed" do
          it "returns an empty array" do
            SocialNetworking::Like.destroy_all
            expect(data).to be_empty
          end
        end

        context "when likes performed" do
          it "returns accurate summaries" do
            participant = participants(:participant1)
            like = SocialNetworking::Like.first
            item = (like.item.try(:item) || like.item)
            expect(data.count).to eq 1
            expect(data).to include(
              participant_id: participant.study_id,
              occurred_at: like.created_at,
              item_type: item.class.to_s
            )
          end
        end
      end
    end
  end
end
