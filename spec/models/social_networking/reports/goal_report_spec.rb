# frozen_string_literal: true
require "spec_helper"

module SocialNetworking
  module Reports
    RSpec.describe Goal do
      fixtures :all

      def data
        @data ||= SocialNetworking::Reports::Goal.all
      end

      describe ".all" do
        context "when no goals created" do
          it "returns an empty array" do
            SocialNetworking::Goal.destroy_all

            expect(data).to be_empty
          end
        end

        context "when goals created" do
          it "returns accurate summaries" do
            participant = participants(:participant1)
            goal = SocialNetworking::Goal.first
            expect(data.count).to be > 10
            expect(data).to include(
              participant_id: participant.study_id,
              created_at: goal.created_at.iso8601,
              due_on: goal.due_on.iso8601,
              is_completed: goal.is_completed,
              is_deleted: goal.is_deleted,
              description: goal.description
            )
          end
        end
      end
    end
  end
end
