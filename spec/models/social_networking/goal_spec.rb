# frozen_string_literal: true
require "spec_helper"

module SocialNetworking
  describe Goal, type: :model do
    fixtures(:participants)
    let(:participant) { participants(:participant1) }

    it "should prevent due dates in the past" do
      goal = Goal.create(due_on: Time.zone.today.advance(days: -1))

      expect(goal.errors[:due_on].length).to eq(1)
    end

    it "should prevent dates past the end of the study membership" do
      allow(participant).to receive(:active_membership_end_date)
        .and_return(Time.zone.today)
      goal = Goal.create(participant: participant,
                         due_on: Time.zone.today.advance(days: 1))

      expect(goal.errors[:due_on].length).to eq(1)
    end

    it "should return the number of goals made today" do
      count = Goal.for_today.count

      Goal.create(
        participant_id: participant.id,
        description: "Write a test that passes.",
        created_at: Time.zone.today
      )

      expect(Goal.for_today.count).to eq(count + 1)
    end

    it "should return the number of goals made in the past seven days" do
      count = Goal.for_week.count

      Goal.create(
        participant_id: participant.id,
        description: "Write a test that passes.",
        created_at: Time.zone.today - 1.day
      )

      Goal.create(
        participant_id: participant.id,
        description: "Write a test that passes.",
        created_at: Time.zone.today - 8.days
      )

      expect(Goal.for_week.count).to eq(count + 1)
    end

    describe ".to_serialized" do
      def goal(attributes = {})
        Goal.create({
          participant: participant,
          description: "foo",
          due_on: Time.zone.today
        }.merge(attributes))
      end

      it "sets `dueOn` property with correct format" do
        expect(goal.to_serialized[:dueOn])
          .to eq Time.zone.today.to_s(:participant_date)
      end

      it "returns an empty hash if `due_on` is nil" do
        expect(goal(due_on: nil).to_serialized)
          .to eq({})
      end
    end

    context "with goal sample data" do
      fixtures(:all)

      it "should return an incomplete goal" do
        expect(Goal.did_not_complete.count).to be > 0
      end

      it "should return no incomplete goals" do
        expect { Goal.find_by(description: "p1 omega").delete }
          .to change { Goal.did_not_complete.count }.by(-1)
      end
    end

    context ".action" do
      def goal(attributes = {})
        Goal.create({
          participant: participant,
          description: "DESCription",
          due_on: Time.zone.today
        }.merge(attributes))
      end

      it "is 'Completed' if the goal was completed" do
        expect(goal(
          completed_at: Time.zone.today.advance(days: -2)
        ).action).to eq "Completed"
      end

      it "is 'Did Not Complete' if in the past and goal not completed" do
        expect(goal(
          due_on: Time.zone.today.advance(days: -1)
        ).action).to eq "Did Not Complete"
      end

      it "is 'Created' if due on is nil" do
        expect(goal(
          due_on: nil
        ).action).to eq "Created"
      end

      it "is 'Created' when due in the future and goal is not completed" do
        puts "mock #{Time.zone.today + 1.day}"
        expect(goal(
          due_on: Time.zone.today + 1.day
        ).action).to eq "Created"
      end
    end
  end
end
