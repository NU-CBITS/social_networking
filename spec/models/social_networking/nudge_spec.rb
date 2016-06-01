# frozen_string_literal: true
require "spec_helper"

module SocialNetworking
  describe Nudge, type: :model do
    fixtures(:participants, :"social_networking/goals")
    let(:participant1) { participants(:participant1) }
    let(:participant2) { participants(:participant2) }
    let(:goal) { social_networking_goals(:participant2_goal_alpha) }

    it "should return the nudges given today" do
      count = Nudge.for_today.count

      Nudge.create(
        initiator_id: participant1.id,
        recipient_id: participant2.id,
        created_at: Time.zone.today
      )

      expect(Nudge.for_today.count).to eq(count + 1)
    end

    it "should return the number of nudges given in the past seven days" do
      count = Nudge.for_week.count

      Nudge.create(
        initiator_id: participant1.id,
        recipient_id: participant2.id,
        created_at: Time.zone.today - 1.day
      )

      Nudge.create(
        initiator_id: participant1.id,
        recipient_id: participant2.id,
        created_at: Time.zone.today - 8.days
      )

      expect(Nudge.for_week.count).to eq(count + 1)
    end
  end
end
