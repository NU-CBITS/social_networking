# frozen_string_literal: true
require "spec_helper"

module SocialNetworking
  describe OnTheMindStatement, type: :model do
    fixtures :participants, :"social_networking/goals",
             :"social_networking/on_the_mind_statements"
    let(:participant1) { participants(:participant1) }
    let(:participant2) { participants(:participant2) }
    let(:goal) { social_networking_goals(:participant2_goal_alpha) }

    it "should return the number of on the mind statements made today" do
      count = OnTheMindStatement.for_today.count

      OnTheMindStatement.create(
        participant_id: participant1.id,
        description: "I'm writing tests.",
        created_at: Time.zone.today
      )

      expect(OnTheMindStatement.for_today.count).to eq(count + 1)
    end

    it "should return the number of statements made in the past seven days" do
      count = OnTheMindStatement.for_week.count

      OnTheMindStatement.create(
        participant_id: participant1.id,
        description: "I'm writing tests.",
        created_at: Time.zone.today - 1.day
      )

      OnTheMindStatement.create(
        participant_id: participant1.id,
        description: "I'm writing tests.",
        created_at: Time.zone.today - 8.days
      )

      expect(OnTheMindStatement.for_week.count).to eq(count + 1)
    end

    it "should return a shared item description" do
      otms = OnTheMindStatement.create(
        participant_id: participant1.id,
        description: "I'm writing tests.",
        created_at: Time.zone.today - 1.day
      )

      expect(otms.shared_description).to eq("I'm writing tests.")
    end

    describe "when a statement exists" do
      let(:statement) do
        social_networking_on_the_mind_statements :participant1_statement1
      end

      describe "and someone has liked the statement" do
        before do
          statement.likes.create!(participant: participant2)
        end

        describe "upon deletion" do
          it "will delete the associated like" do
            expect { statement.destroy }.to change {
              participant2.social_networking_likes.count
            }.by(-1)
          end
        end
      end

      describe "and someone has commented on the statement" do
        before do
          statement.comments.create!(participant: participant2, text: "foo")
        end

        describe "upon deletion" do
          it "will delete the associated comment" do
            expect { statement.destroy }.to change {
              participant2.social_networking_comments.count
            }.by(-1)
          end
        end
      end
    end
  end
end
