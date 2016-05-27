# frozen_string_literal: true
require "spec_helper"

module SocialNetworking
  RSpec.describe "social_networking/coach/patient_dashboards"\
                 "/tables/_on_my_mind_statements.html.erb",
                 type: :view do
    describe "Shared on my mind statements" do
      let(:statement) do
        instance_double(
          OnTheMindStatement,
          created_at: Time.zone.now
        )
      end
      let(:membership) { instance_double(::Membership) }

      describe "Statments exist" do
        before do
          expect(membership)
            .to receive(:on_the_minds) { [statement] }
          expect(statement)
            .to receive_messages(
              comments: [],
              description: "Windy cIty raiLz",
              likes: []
            )
          expect(view)
            .to receive_messages(week_in_study: 1)

          render partial: "social_networking/coach/patient_dashboards"\
                 "/tables/on_my_mind_statements",
                 locals: { membership: membership }
        end

        it "displays description" do
          expect(rendered).to have_text "Windy cIty raiLz"
        end

        it "displays correct formatted date time" do
          expect(rendered).to have_text statement.created_at.to_s(:standard)
        end
      end
    end
  end
end
