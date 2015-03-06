require "spec_helper"

module SocialNetworking
  describe Like, type: :model do
    fixtures(:participants, :"social_networking/goals")
    let(:participant1) { participants(:participant1) }
    let(:goal) { social_networking_goals(:participant2_goal_alpha) }

    it "should return the number of likes given today" do
      count = Like.for_today.count

      Like.create(
        participant_id: participant1.id,
        item_id: goal.id,
        item_type: "SocialNetworking::Goal",
        created_at: Date.today
      )

      expect(Like.for_today.count).to eq(count + 1)
    end

    it "should return the number of likes given in the past seven days" do
      count = Like.for_week.count

      Like.create(
          participant_id: participant1.id,
          item_id: goal.id,
          item_type: "SocialNetworking::Goal",
          created_at: Date.today - 1.day
      )

      Like.create(
          participant_id: participant1.id,
          item_id: goal.id,
          item_type: "SocialNetworking::Goal",
          created_at: Date.today - 8.days
      )

      expect(Like.for_week.count).to eq(count + 1)
    end
  end
end
