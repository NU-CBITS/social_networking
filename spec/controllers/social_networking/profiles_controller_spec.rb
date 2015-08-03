require "spec_helper"

module SocialNetworking
  describe ProfilesController, type: :controller do
    context "participant is authenticated" do
      let(:participant) { double("participant") }
      let(:profile) { double("profile") }

      before do
        @routes = Engine.routes
        allow(controller).to receive(:current_participant) { participant }
        allow(participant)
          .to receive_message_chain(:social_networking_profile,
                                    :find) { profile }
      end

      describe "PUT update" do
        context "update succeeds" do
          it "renders serialized profile" do
            allow(profile).to receive_messages(update: true)

            expect(Serializers::ProfileSerializer)
              .to receive_message_chain(:new, :to_serialized)

            put :update, icon_name: "purse", id: 1

            assert_response 200
          end
        end

        context "update fails" do
          let(:errors) { double("errors", full_messages: ["epic fail"]) }

          it "renders error message" do
            allow(profile).to receive_messages(update: false, errors: errors)
            put :update, icon_name: "purse", id: 1

            assert_response 400
            expect(json["error"]).to eq ["epic fail"]
          end
        end
      end
    end
  end
end
