require "spec_helper"

module SocialNetworking
  describe Goal, type: :model do
    fixtures(:participants)

    it "should prevent due dates in the past" do
      goal = Goal.create(due_on: Date.today.advance(days: -1))

      expect(goal.errors[:due_on].length).to eq(1)
    end

    it "should prevent dates past the end of the study membership" do
      participant = participants(:participant10)
      allow(participant).to receive(:active_membership_end_date) { Date.today }
      goal = Goal.create(participant: participant,
                         due_on: Date.today.advance(days: 1))

      expect(goal.errors[:due_on].length).to eq(1)
    end
  end
end
