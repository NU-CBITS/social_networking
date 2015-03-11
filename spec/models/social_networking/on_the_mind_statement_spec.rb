require "spec_helper"

module SocialNetworking
  describe OnTheMindStatement, type: :model do
    fixtures(:participants, :"social_networking/goals")
    let(:participant1) { participants(:participant1) }
    let(:goal) { social_networking_goals(:participant2_goal_alpha) }

    it "should return the number of on the mind statements made today" do
      count = OnTheMindStatement.for_today.count

      OnTheMindStatement.create(
        participant_id: participant1.id,
        description: "I'm writing tests.",
        created_at: Date.today
      )

      expect(OnTheMindStatement.for_today.count).to eq(count + 1)
    end

    it "should return the number of statements made in the past seven days" do
      count = OnTheMindStatement.for_week.count

      OnTheMindStatement.create(
        participant_id: participant1.id,
        description: "I'm writing tests.",
        created_at: Date.today - 1.day
      )

      OnTheMindStatement.create(
        participant_id: participant1.id,
        description: "I'm writing tests.",
        created_at: Date.today - 8.days
      )

      expect(OnTheMindStatement.for_week.count).to eq(count + 1)
    end

    it "should return a shared item description" do
      otms = OnTheMindStatement.create(
        participant_id: participant1.id,
        description: "I'm writing tests.",
        created_at: Date.today - 1.day
      )

      expect(otms.shared_description).to eq("I'm writing tests.")
    end
  end
end
