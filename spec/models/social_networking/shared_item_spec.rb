require "spec_helper"

module SocialNetworking
  describe SharedItem, type: :model do
    fixtures(:participants, :"social_networking/goals")

    it "should add an item's participant id upon save" do
      goal = social_networking_goals(:participant1_goal_alpha)
      shared_item = SharedItem.create(item: goal, action_type: "action_type")
      expect(shared_item.participant_id).to eq(700_141_617)
    end
  end
end
