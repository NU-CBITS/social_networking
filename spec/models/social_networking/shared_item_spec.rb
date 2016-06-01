# frozen_string_literal: true
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
      let(:on_the_mind_statement) do
        OnTheMindStatement
          .create!(participant_id: participants(:participant1).id,
                   description: "otms description")
      end

      it "the action type is set on a shared item" do
        otms = on_the_mind_statement
        shared_item = SharedItem.create!(item: otms)
        expect(shared_item.action_type).to eq("Shared")
      end
    end
  end
end
