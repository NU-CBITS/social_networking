# frozen_string_literal: true
require "spec_helper"

module SocialNetworking
  RSpec.describe "social_networking/coach/patient_dashboards"\
                 "/tables/_likes.html.erb",
                 type: :view do
    describe "Shared items are liked" do
      let(:like) { instance_double(Like, created_at: Time.zone.now) }
      let(:membership) { double(Membership) }

      describe "Likes exist" do
        before do
          expect(membership)
            .to receive(:likes) { [like] }
          expect(view)
            .to receive_messages(comment_item_description: "bar",
                                 week_in_study: 1)
        end

        it "displays correct formatted date time" do
          render partial: "social_networking/coach/patient_dashboards"\
                 "/tables/likes",
                 locals: { membership: membership }

          expect(rendered).to have_text like.created_at.to_s(:standard)
        end
      end
    end
  end
end
