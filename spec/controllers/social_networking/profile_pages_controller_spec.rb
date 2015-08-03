require "spec_helper"

module SocialNetworking
  describe ProfilePagesController, type: :controller do
    let(:group) { double("group", social_networking_profile_questions: []) }
    let(:participant_status) { double("participant_status", :context= => "") }
    let(:participant) do
      double(
        "participant",
        active_group: group,
        navigation_status: participant_status)
    end
    let(:initiator) { double("participant") }

    describe "GET show" do
      context "when the current participant is authenticated" do
        before do
          @routes = Engine.routes
          allow(controller).to receive(:authenticate_participant!)
          allow(controller).to receive(:current_participant) { participant }
        end

        context "when params contains profile id" do
          after do
            get :show, id: 1
          end

          context "current participant has been nudged" do
            let(:nudge) { double("nudge", initiator: initiator) }

            it "displays the display name of the participant who nudged" do
              allow(Nudge).to receive(:search) { [nudge] }

              expect(initiator).to receive(:display_name)
            end
          end
        end
      end
    end
  end
end
