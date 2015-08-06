require "spec_helper"

module SocialNetworking
  describe ProfilesController, type: :controller do
    context "participant is authenticated" do
      let(:participant) { instance_double("participant") }
      let(:profile) { instance_double("profile") }

      before do
        @routes = Engine.routes

        expect(controller).to receive(:current_participant) { participant }
        expect(participant)
          .to receive_message_chain(:social_networking_profile) { profile }
      end

      describe "PUT update" do
        context "update succeeds" do
          it "renders serialized profile" do
            expect(profile).to receive_messages(update: true)
            expect(Serializers::ProfileSerializer)
              .to receive_message_chain(:new, :to_serialized)

            put :update, id: 1

            assert_response 200
          end
        end

        context "update fails" do
          let(:errors) { double("errors", full_messages: ["epic fail"]) }

          it "renders error message" do
            expect(profile).to receive_messages(update: false, errors: errors)

            put :update, id: 1

            assert_response 400
            expect(json["error"]).to eq ["epic fail"]
          end
        end
      end
    end
  end
end
