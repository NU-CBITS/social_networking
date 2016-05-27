# frozen_string_literal: true
require "spec_helper"

module SocialNetworking
  RSpec.describe "social_networking/goals/tool.html.erb",
                 type: :view do
    describe "Viewing ACHIEVE tool" do
      before do
        allow(view)
          .to receive(:current_participant)
          .and_return(
            instance_double(
              Participant,
              id: 1,
              active_membership_end_date: Date.new
            )
          )
        allow(view)
          .to receive(:goals)
      end

      it "gives detailed description of how to use the goal" do
        render

        expect(rendered)
          .to match "The ACHIEVE tool helps you set goals."
      end
    end
  end
end
