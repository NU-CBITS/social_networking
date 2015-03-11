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
      it "should return an description for Goal likes" do
        shared_item = double("shared_item",
                             item_type: "SocialNetworking::Goal",
                             item_id: 1)
        goal_like = create_generic_like(participant1.id,
                                        goal.id,
                                        "SocialNetworking::SharedItem")
        expect(goal_like).to receive(:item).exactly(3).times { shared_item }
        expect(SocialNetworking::Goal).to receive(:find) { goal }
        expect(goal_like.item_description).to eq("participant_study_id: p2 alpha")
      end

      it "should return a description for onTheMindStatement likes" do
        otms = double("otms", description: "otms description goes here")
        otms_like = create_generic_like(participant1.id,
                                        goal.id,
                                        "SocialNetworking::OnTheMindStatement")
        expect(SocialNetworking::OnTheMindStatement).to receive(:find) { otms }
        expect(otms_like.item_description).to eq("otms description goes here")
      end

      it "should return a description for Activity likes" do
        activity = double("activity",
                          activity_type: double("activity_type",
                                                title: "activity title"))
        shared_item = double("shared_item",
                             item_type: "Activity",
                             item_id: 1,
                             item: activity)
        activity_like = create_generic_like(participant1.id,
                                            goal.id,
                                            "SocialNetworking::SharedItem")
        expect(activity_like).to receive(:item).exactly(3)
                                   .times { shared_item }
        expect(Activity).to receive(:find) { activity }
        expect(activity).to receive(:participant) { participant1 }
        expect(activity_like.item_description)
          .to eq("participant_study_id: activity title")
      end

      it "should return a description for ProfileCreation likes" do
        profile = double("profile", participant: participant1)
        shared_item = double("shared_item",
                             item_type: "SocialNetworking::Profile",
                             item: profile,
                             participant: participant1)

        profile_like = create_generic_like(participant1.id,
                                           goal.id,
                                           "SocialNetworking::SharedItem")
        expect(profile_like).to receive(:item).exactly(3).times { shared_item }
        expect(profile_like.item_description)
          .to eq("ProfileCreation: participant_study_id")
      end

      it "should return a description for Thought likes" do
        thought = double("thought",
                         description: "thought description goes here",
                         participant: participant1)
        shared_item = double("shared_item",
                             item_type: "Thought",
                             item_id: 1,
                             item: thought)
        thought_like = create_generic_like(participant1.id,
                                           goal.id,
                                           "SocialNetworking::SharedItem")
        expect(thought_like).to receive(:item).exactly(3).times { shared_item }
        expect(Thought).to receive(:find) { thought }
        expect(thought_like.item_description)
          .to eq("participant_study_id: thought description goes here")
      end

      it "should return a description for Unknown Item Typed likes" do
        unknown_like = create_generic_like(participant1.id,
                                           goal.id,
                                           "SocialNetworking::SharedItem")
        expect(unknown_like.item_description)
          .to eq("Like was for an unknown item (for reporting tool).")
      end

      it "should return a description for Unknown Shared Item Typed likes" do
        unknown_like_item = double("like_item", item_type: "unknown")
        unknown_like = create_generic_like(participant1.id,
                                           goal.id,
                                           "SocialNetworking::SharedItem")
        expect(unknown_like).to receive(:item).exactly(2)
                                  .times { unknown_like_item }
        expect(unknown_like.item_description)
          .to start_with("Unknown SharedItem Type (reporting), Item ID:")
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

