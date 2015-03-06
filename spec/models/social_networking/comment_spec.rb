require "spec_helper"

module SocialNetworking
  describe Comment, type: :model do
    fixtures(:participants, :"social_networking/goals")
    let(:participant1) { participants(:participant1) }
    let(:goal) { social_networking_goals(:participant2_goal_alpha) }

    it "should return the number of comments made today" do
      count = Comment.for_today.count

      Comment.create(
        participant_id: participant1.id,
        item_id: goal.id,
        text: "love this test",
        item_type: "SocialNetworking::Goal",
        created_at: Date.today
      )

      expect(Comment.for_today.count).to eq(count + 1)
    end

    it "should return the number of comments made in the past seven days" do
      count = Comment.for_week.count

      Comment.create(
        participant_id: participant1.id,
        item_id: goal.id,
        text: "love this test",
        item_type: "SocialNetworking::Goal",
        created_at: Date.today - 1.days
      )

      Comment.create(
        participant_id: participant1.id,
        item_id: goal.id,
        text: "love this test",
        item_type: "SocialNetworking::Goal",
        created_at: Date.today - 8.days
      )

      expect(Comment.for_week.count).to eq(count + 1)
    end
  end
end
