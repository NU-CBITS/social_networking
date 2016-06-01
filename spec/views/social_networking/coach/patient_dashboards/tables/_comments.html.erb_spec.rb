# frozen_string_literal: true
require "spec_helper"

module SocialNetworking
  RSpec.describe "social_networking/coach/patient_dashboards"\
                 "/tables/_comments.html.erb",
                 type: :view do
    describe "Shared comments" do
      let(:comment) do
        instance_double(Comment,
                        created_at: Time.zone.now,
                        text: "foo")
      end
      let(:membership) { instance_double(::Membership) }

      describe "Comments exist" do
        before do
          expect(membership)
            .to receive(:comments) { [comment] }
          expect(view)
            .to receive_messages(comment_item_description: "bar",
                                 week_in_study: 1)

          render partial: "social_networking/coach/patient_dashboards"\
                 "/tables/comments",
                 locals: { membership: membership }
        end

        it "displays comment text" do
          expect(rendered).to have_text "foo"
        end

        it "displays correct formatted date time" do
          expect(rendered).to have_text comment.created_at.to_s(:standard)
        end
      end
    end
  end
end
