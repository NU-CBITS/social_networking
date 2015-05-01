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
            like = SocialNetworking::Like
                   .find_by_participant_id(participant.id)
            item = (like.item.try(:item) || like.item)

            expect(data.count).to eq SocialNetworking::Like.count
            expect(data).to include(
              participant_id: participant.study_id,
              occurred_at: like.created_at.iso8601,
              item_type: item.class.to_s,
              item_participant_id: item.participant.study_id,
              item_content: like.item_description
            )
          end
        end
      end
    end
  end
end
