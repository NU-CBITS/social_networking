require "spec_helper"

module SocialNetworking
  describe GoalsController, type: :controller do
    describe "POST create" do
      context "when the participant is authenticated" do
        let(:participant) { double("participant", id: 987) }
        let(:goal) do
          double("goal",
                 id: 8_675_309,
                 participant_id: participant.id,
                 description: "run a marathon")
        end

        before do
          allow(controller).to receive(:authenticate_participant!)
          allow(controller).to receive(:current_participant) { participant }

          expect(Goal).to receive(:new).with(
            participant_id: participant.id,
            description: "run a marathon"
          ) { goal }
        end

        context "and the record saves" do
          before { allow(goal).to receive(:save) { true } }

          it "should return the new record" do
            post :create,
                 description:
                 "run a marathon",
                 use_route: :social_networking

            assert_response 200
            expect(json["id"]).to eq(8_675_309)
            expect(json["description"]).to eq("run a marathon")
            expect(json["participantId"]).to eq(987)
          end
        end

        context "and the record doesn't save" do
          let(:errors) { double("errors", full_messages: ["baz"]) }

          before do
            allow(goal).to receive_messages(save: false, errors: errors)
          end

          it "should return the error message" do
            post :create,
                 description: "run a marathon",
                 use_route: :social_networking

            assert_response 400
            expect(json["error"]).to eq("baz")
          end
        end
      end
    end
  end
end
