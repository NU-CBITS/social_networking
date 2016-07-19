# frozen_string_literal: true
require "spec_helper"

module SocialNetworking
  describe Comment, type: :model do
    fixtures(:participants, :"social_networking/goals")
    let(:participant1) { participants(:participant1) }
    let(:goal) { social_networking_goals(:participant2_goal_alpha) }

    it "should return the number of comments made today" do
      expect do
        Comment.create(
          participant_id: participant1.id,
          item: goal,
          text: "love this test",
          created_at: Time.zone.today
        )
      end.to change { Comment.for_today.count }.by(1)
    end

    it "should return the number of comments made in the past seven days" do
      expect do
        Comment.create(
          participant_id: participant1.id,
          item: goal,
          text: "love this test",
          created_at: Time.zone.today - 1.day
        )

        Comment.create(
          participant_id: participant1.id,
          item: goal,
          text: "love this test",
          created_at: Time.zone.today - 8.days
        )
      end.to change { Comment.for_week.count }.by(1)
    end

    describe "#item_description" do
      it "should return an description for SharedItem type" do
        shareable = double("shareable", description: "goal description")
        goal = double("goal", description: "goal description", id: 1)
        shared_item = double("shared_item",
                             item_type: "SocialNetworking::Goal",
                             item: goal)
        goal_comment = create_generic_comment(participant1.id,
                                              goal.id,
                                              "SocialNetworking::SharedItem")
        expect(goal_comment).to receive(:item).exactly(2).times { shared_item }
        expect(Shareable).to receive(:new) { shareable }
        expect(goal_comment.item_description)
          .to eq("goal description")
      end

      it "should return a description for onTheMindStatement comments" do
        shareable = double("shareable", description: "otms description")
        otms_comment = create_generic_comment(
          participant1.id,
          goal.id,
          "SocialNetworking::OnTheMindStatement"
        )
        expect(Shareable).to receive(:new) { shareable }
        expect(otms_comment.item_description).to eq("otms description")
      end

      it "should return a generic description for a nil item" do
        unknown_comment = create_generic_comment(participant1.id,
                                                 goal.id,
                                                 "SocialNetworking::SharedItem")
        shareable =
          double("shareable",
                 description: "Description not available for this item.")
        expect(unknown_comment).to receive(:item) { nil }
        expect(Shareable).to receive(:new) { shareable }
        expect(unknown_comment.item_description)
          .to eq("Description not available for this item.")
      end

      def create_generic_comment(participant_id, item_id, item_type)
        Like.create(
          participant_id: participant_id,
          item_id: item_id,
          item_type: item_type,
          created_at: Time.zone.today - 1.day
        )
      end
    end
  end
end
