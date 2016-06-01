# frozen_string_literal: true
require "spec_helper"

module SocialNetworking
  RSpec.describe "social_networking/coach/patient_dashboards"\
                 "/tables/_initiator_nudges.html.erb",
                 type: :view do
    context "with two nudges" do
      let(:participant1) { instance_double(Participant, study_id: "foo") }
      let(:participant2) { instance_double(Participant, study_id: "bar") }
      let(:received) do
        instance_double(
          Nudge,
          created_at: Time.zone.now,
          initiator: participant2,
          recipient: participant1
        )
      end
      let(:sent) do
        instance_double(
          Nudge,
          created_at: Time.zone.now + 1.hour,
          initiator: participant1,
          recipient: participant2
        )
      end

      describe "Sent Nudges" do
        before do
          render partial: "social_networking/coach/patient_dashboards"\
                 "/tables/nudges/initiator_nudges.html.erb",
                 locals: { nudges: [sent] }
        end

        it "displays table heading" do
          expect(rendered).to have_text "Nudges Initiated"
        end

        it "displays each sent nudge's formated created_at time" do
          expect(rendered).to have_text sent.created_at.to_s(:standard)
        end

        it "displays sent nudges recipient's study id" do
          expect(rendered).to match participant2.study_id
        end
      end
    end
  end
end
