require "spec_helper"

module SocialNetworking
  describe ProfilePagesController, type: :controller do
    let(:group) { double("group", social_networking_profile_questions: []) }
    let(:participant) do
      instance_double(
        Participant,
        active_group: group,
        id: 1)
    end
    let(:profile) { instance_double(Profile, participant_id: 1, active: nil) }
    let(:initiator) { instance_double(Participant) }
    let(:nudge) { instance_double(Nudge, initiator: initiator) }

    describe "GET show" do
      context "when the current participant is authenticated" do
        before do
          @routes = Engine.routes
          allow(controller).to receive(:current_participant) { participant }

          expect(controller).to receive(:store_nudge_initiators)
          expect(controller).to receive(:set_member_profiles)
          expect(controller).to receive(:load_feed_items)
        end

        context "when params contains profile id" do
          it "finds profile" do
            expect(Profile).to receive(:find) { profile }

            get :show, id: 1
          end
        end

        context "when viewing personal profile" do
          it "finds or initializes a new profile" do
            expect(Profile)
              .to receive(:find_or_initialize_by) { profile }
            expect(profile)
              .to receive(:update_attributes).with(active: true)

            get :show
          end
        end
      end
    end
  end
end
