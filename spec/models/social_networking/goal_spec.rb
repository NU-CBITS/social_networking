require "spec_helper"

module SocialNetworking
  describe Goal, type: :model do
    fixtures(:participants)
    let(:participant) { participants(:participant1) }

    it "should prevent due dates in the past" do
      goal = Goal.create(due_on: Date.today.advance(days: -1))

      expect(goal.errors[:due_on].length).to eq(1)
    end

    it "should prevent dates past the end of the study membership" do
      allow(participant).to receive(:active_membership_end_date) { Date.today }
      goal = Goal.create(participant: participant,
                         due_on: Date.today.advance(days: 1))

      expect(goal.errors[:due_on].length).to eq(1)
    end

    it "should return the number of goals made today" do
      count = Goal.for_today.count

      Goal.create(
        participant_id: participant.id,
        description: "Write a test that passes.",
        created_at: Date.today
      )

      expect(Goal.for_today.count).to eq(count + 1)
    end

    it "should return the number of goals made in the past seven days" do
      count = Goal.for_week.count

      Goal.create(
        participant_id: participant.id,
        description: "Write a test that passes.",
        created_at: Date.today - 1.day
      )

      Goal.create(
        participant_id: participant.id,
        description: "Write a test that passes.",
        created_at: Date.today - 8.days
      )

      expect(Goal.for_week.count).to eq(count + 1)
    end

    it "should return an incomplete goal" do
      incomplete_goal = Goal.create(
        participant_id: participant.id,
        description: "return fixture incompletes plus one.",
        due_on: DateTime.now - 1.hour,
        deleted_at: nil,
        completed_at: nil
      )

      expect(Goal.did_not_complete
               .exists?(id: incomplete_goal.id)).to eq(true)
    end

    it "should return no incomplete goals" do
      incomplete_goal = Goal.create(
        participant_id: participant.id,
        description: "return only fixture incomplete goals.",
        due_on: DateTime.now - 2,
        deleted_at: nil,
        completed_at: nil
      )

      expect(Goal.did_not_complete
               .exists?(id: incomplete_goal.id)).to eq(false)
    end
  end
end
