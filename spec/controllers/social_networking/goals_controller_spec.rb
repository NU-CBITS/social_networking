require "spec_helper"

module SocialNetworking
  describe GoalsController, type: :controller do
    let(:participant) { double("participant", id: 987) }
    let(:goal) do
      double("goal",
             id: 8_675_309,
             participant_id: participant.id,
             description: "run a marathon",
             is_completed: false,
             is_deleted: false,
             due_on: Date.today,
             comments: [])
    end
    let(:errors) { double("errors", full_messages: ["baz"]) }

    describe "GET index" do
      context "when the current participant is authenticated" do
        before do
          allow(controller).to receive(:authenticate_participant!)
          allow(controller).to receive(:current_participant) { participant }
          allow(Goal).to receive(:where).with(
            participant_id: participant.id
          ) { [goal] }
        end

        it "should return the goals" do
          get :index, use_route: :social_networking

          assert_response 200
          expect(json.count).to eq(1)
          expect(json[0]["id"]).to eq(8_675_309)
        end
      end
    end

    describe "POST create" do
      context "when the participant is authenticated" do
        before do
          allow(controller).to receive(:authenticate_participant!)
          allow(controller).to receive(:current_participant) { participant }
          allow(Goal).to receive(:new).with(
            participant_id: participant.id,
            description: "run a marathon",
            is_completed: true
          ) { goal }
        end

        context "and the record saves" do
          before { allow(goal).to receive(:save) { true } }

          it "should return the new record" do
            post :create,
                 description: "run a marathon",
                 isCompleted: true,
                 use_route: :social_networking

            assert_response 200
            expect(json["id"]).to eq(8_675_309)
            expect(json["description"]).to eq("run a marathon")
            expect(json["participantId"]).to eq(987)
          end
        end

        context "and the record doesn't save" do
          before do
            allow(goal).to receive_messages(save: false, errors: errors)
          end

          it "should return the error message" do
            post :create,
                 description: "run a marathon",
                 isCompleted: true,
                 use_route: :social_networking

            assert_response 400
            expect(json["error"]).to eq("baz")
          end
        end
      end
    end

    describe "POST update" do
      context "when the participant is authenticated" do
        before do
          allow(controller).to receive(:authenticate_participant!)
          allow(controller).to receive(:current_participant) { participant }
        end

        context "and the record is found" do
          before do
            allow(Goal).to receive(:where).with(
              participant_id: participant.id,
              id: "1234"
            ) { [goal] }
          end

          context "and saves" do
            before do
              allow(goal).to receive(:update).with(
                participant_id: participant.id,
                description: "run a marathon",
                is_completed: true
              ) { true }
            end

            it "should return the record" do
              post :update,
                   id: 1234,
                   description: goal.description,
                   isCompleted: true,
                   use_route: :social_networking

              assert_response 200
              expect(json["participantId"]).to eq(participant.id)
            end
          end

          context "and doesn't save" do
            before do
              allow(goal).to receive(:update) { false }
              allow(goal).to receive(:errors) { errors }
            end

            it "should return an error" do
              post :update,
                   id: 1234,
                   use_route: :social_networking

              assert_response 400
            end
          end
        end

        context "and the record is not found" do
          before do
            allow(Goal).to receive(:where) { [] }
          end

          it "should return an error" do
            post :update,
                 id: 1234,
                 use_route: :social_networking

            assert_response 404
          end
        end
      end
    end
  end
end
