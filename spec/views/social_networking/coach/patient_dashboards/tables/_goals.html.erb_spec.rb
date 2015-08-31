require "spec_helper"

module SocialNetworking
  RSpec.describe "social_networking/coach/patient_dashboards"\
                 "/tables/_goals.html.erb",
                 type: :view do
    describe "Shared goals exist" do
      let(:membership) { instance_double(::Membership) }

      def goal_double(attrs = {})
        instance_double(
          Goal, {
            completed_at: Time.zone.now,
            created_at: Time.zone.now + 1.hours,
            deleted_at: Time.zone.now + 2.hours,
            due_on: Date.today,
            description: "",
            comments: [] }
          .merge(attrs))
      end

      def set_stubs(membership:, goal:)
        expect(membership)
          .to receive(:goals) { [goal]  }
        expect(goal)
          .to receive_messages(
            description: "",
            comments: [])

        render partial: "social_networking/coach/patient_dashboards"\
               "/tables/goals",
               locals: { membership: membership }
      end

      before do
        expect(view)
          .to receive_messages(
            week_in_study: 1,
            goal_like_count: 1)
      end

      describe "Goal(s) exist" do
        describe "when created" do
          let(:goal) { goal_double }

          it "displays timestamp" do
            set_stubs(membership: membership, goal: goal)

            expect(rendered).to have_text goal.created_at.to_s(:standard)
          end
        end

        describe "completion status" do
          describe "when completed" do
            let(:goal) { goal_double }

            it "displays timestamp" do
              set_stubs(membership: membership, goal: goal)

              expect(rendered).to have_text goal.completed_at.to_s(:standard)
            end
          end

          describe "when incomplete" do
            let(:goal) { goal_double(completed_at: nil) }

            it "displays message" do
              set_stubs(membership: membership, goal: goal)

              expect(rendered).to have_text "Incomplete"
            end
          end
        end

        describe "delete status" do
          describe "when deleted" do
            let(:goal) { goal_double }

            it "displays timestamp" do
              set_stubs(membership: membership, goal: goal)

              expect(rendered).to have_text goal.deleted_at.to_s(:standard)
            end
          end

          describe "when not deleted" do
            let(:goal) { goal_double(deleted_at: nil) }

            it "displays message" do
              set_stubs(membership: membership, goal: goal)

              expect(rendered).to have_text "Not Deleted"
            end
          end
        end

        describe "due date status" do
          describe "when due date exists" do
            let(:goal) { goal_double }

            it "displays timestamp" do
              set_stubs(membership: membership, goal: goal)

              expect(rendered).to have_text goal.due_on.to_s(:user_date)
            end
          end

          describe "when not due" do
            let(:goal) { goal_double(due_on: nil) }

            it "displays message" do
              set_stubs(membership: membership, goal: goal)

              expect(rendered).to have_text "Unscheduled"
            end
          end
        end
      end
    end
  end
end
