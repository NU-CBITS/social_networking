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
  end
end
