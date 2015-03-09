require "spec_helper"

module SocialNetworking
  describe SharedItem, type: :model do
    fixtures(:participants, :"social_networking/goals")

    it "should add an item's participant id upon save" do
      goal = social_networking_goals(:participant1_goal_alpha)
      shared_item = SharedItem.create(item: goal, action_type: "action_type")
      expect(shared_item.participant_id).to eq(700_141_617)
    end

    describe "when saving" do
      let(:activity) do
        Activity.create!(participant_id: participants(:participant1).id)
      end

      it "the action type is set on a shared item" do
        allow(activity).to receive(:action).and_return("Monitored")
        shared_item = SharedItem.create!(item: activity)

        expect(shared_item.action_type).to eq("Monitored")
      end
    end
  end
end
