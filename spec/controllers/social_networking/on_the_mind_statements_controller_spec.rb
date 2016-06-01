# frozen_string_literal: true
require "spec_helper"

module SocialNetworking
  describe OnTheMindStatementsController, type: :controller do
    describe "POST create" do
      context "when the participant is authenticated" do
        let(:participant) { double("participant", id: 987, is_admin: false) }
        let(:on_the_mind_statement) do
          double("on_the_mind_statement",
                 id: 8_675_309,
                 created_at: Time.zone.now,
                 participant_id: participant.id,
                 participant: participant,
                 description: "foo",
                 comments: [],
                 likes: [])
        end

        before do
          @routes = Engine.routes
          allow(controller).to receive(:authenticate_participant!)
          allow(controller).to receive(:current_participant) { participant }

          expect(OnTheMindStatement).to receive(:new).with(
            participant_id: participant.id,
            description: "foo"
          ) { on_the_mind_statement }
        end

        context "and the record saves" do
          before { allow(on_the_mind_statement).to receive(:save) { true } }

          it "should return the new record" do
            post :create, description: "foo"

            assert_response 200
            expect(json["id"]).to eq(8_675_309)
            expect(json["description"]).to eq("foo")
            expect(json["participantId"]).to eq(987)
          end
        end

        context "and the record doesn't save" do
          let(:errors) { double("errors", full_messages: ["baz"]) }

          before do
            allow(on_the_mind_statement)
              .to receive_messages(save: false, errors: errors)
          end

          it "should return the error message" do
            post :create, description: "foo"

            assert_response 400
            expect(json["error"]).to eq("baz")
          end
        end
      end
    end
  end
end
