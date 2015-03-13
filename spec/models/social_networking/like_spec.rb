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

    context "#item_description is called" do
      it "should return an description for SharedItem type" do
        shareable = double("shareable", description: "goal description")
        goal = double("goal", description: "goal description", id: 1)
        shared_item = double("shared_item",
                             item_type: "SocialNetworking::Goal",
                             item: goal)
        goal_like = create_generic_like(participant1.id,
                                        goal.id,
                                        "SocialNetworking::SharedItem")
        expect(goal_like).to receive(:item).exactly(2).times { shared_item }
        expect(Shareable).to receive(:new) { shareable }
        expect(goal_like.item_description)
          .to eq("goal description")
      end

      it "should return a description for onTheMindStatement likes" do
        shareable = double("shareable", description: "otms description")
        otms_like = create_generic_like(participant1.id,
                                        goal.id,
                                        "SocialNetworking::OnTheMindStatement")
        expect(Shareable).to receive(:new) { shareable }
        expect(otms_like.item_description).to eq("otms description")
      end

      it "should return a generic description for a nil item" do
        unknown_like = create_generic_like(participant1.id,
                                           goal.id,
                                           "SocialNetworking::SharedItem")
        shareable =
          double("shareable",
                 description: "Description not available for this item.")
        expect(unknown_like).to receive(:item) { nil }
        expect(Shareable).to receive(:new) { shareable }
        expect(unknown_like.item_description)
          .to eq("Description not available for this item.")
      end

      def create_generic_like(participant_id, item_id, item_type)
        Like.create(
          participant_id: participant_id,
          item_id: item_id,
          item_type: item_type,
          created_at: Date.today - 1.day
        )
      end
    end
  end
end
