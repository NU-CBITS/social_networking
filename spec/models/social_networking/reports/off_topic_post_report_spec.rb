require "spec_helper"

module SocialNetworking
  module Reports
    RSpec.describe OffTopicPost do
      fixtures :all

      def data
        @data ||= OffTopicPost.all
      end

      describe ".all" do
        context "when no 'on the mind' statements made" do
          it "returns an empty array" do
            SocialNetworking::OnTheMindStatement.destroy_all
            expect(data).to be_empty
          end
        end

        context "when 'on the mind' statements made" do
          it "returns accurate summaries" do
            participant = participants(:participant1)
            statement = SocialNetworking::OnTheMindStatement.first
            expect(data.count).to eq 2
            expect(data).to include(
              participant_id: participant.study_id,
              occurred_at: statement.created_at,
              description: statement.description
            )
          end
        end
      end
    end
  end
end
