require "spec_helper"

module SocialNetworking
  describe NudgesController, type: :controller do
    describe "POST create" do
      context "when the participant is authenticated" do
        let(:participant) { double("participant", id: 987) }
        let(:nudge) do
          double("nudge",
                 id: 8_675_309,
                 created_at: DateTime.new,
                 initiator_id: participant.id,
                 recipient_id: 123,
                 comments: [])
        end

        before do
          allow(controller).to receive(:authenticate_participant!)
          allow(controller).to receive(:current_participant) { participant }

          expect(Nudge).to receive(:new).with(
            initiator_id: participant.id,
            recipient_id: "123"
          ) { nudge }
          allow(Profile).to receive(:find_by_participant_id)
            .and_return(double("profile", user_name: "F. Bar"))
        end

        context "and the record saves" do
          before { allow(nudge).to receive(:save) { true } }

          it "should return the new record" do
            post :create, recipientId: 123, use_route: :social_networking

            assert_response 200
            expect(json["id"]).to eq(8_675_309)
            expect(json["recipientId"]).to eq(123)
            expect(json["initiatorId"]).to eq(987)
          end
        end

        context "and the record doesn't save" do
          let(:errors) { double("errors", full_messages: ["baz"]) }

          before do
            allow(nudge).to receive_messages(save: false, errors: errors)
          end

          it "should return the error message" do
            post :create, recipientId: 123, use_route: :social_networking

            assert_response 400
            expect(json["error"]).to eq("baz")
          end
        end
      end
    end
  end
end
