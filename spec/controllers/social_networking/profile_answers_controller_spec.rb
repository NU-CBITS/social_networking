# frozen_string_literal: true
require "spec_helper"

module SocialNetworking
  describe ProfileAnswersController, type: :controller do
    context "participant is authenticated" do
      let(:participant) { double("participant") }
      let(:answer) { double("profile_answer") }
      let(:errors) { double("errors", full_messages: ["epic fail"]) }

      before do
        @routes = Engine.routes
        allow(controller).to receive(:authenticate_participant!)
        allow(controller).to receive(:current_participant) { participant }
      end

      describe "POST create" do
        before do
          allow(participant)
            .to receive_message_chain(:social_networking_profile, :id)
          allow(ProfileAnswer).to receive(:new) { answer }
        end

        context "create succeeds" do
          it "renders the serialized answer" do
            allow(answer).to receive(:save) { true }

            expect(Serializers::ProfileAnswerSerializer)
              .to receive_message_chain(:new, :to_serialized)

            post :create
          end
        end

        context "create fails" do
          it "renders error message" do
            allow(answer).to receive_messages(save: false, errors: errors)
            post :create

            assert_response 400
            expect(json["error"]).to eq "epic fail"
          end
        end
      end

      describe "POST update" do
        context "profile answer is not found" do
          it "renders error message" do
            allow(participant)
              .to receive_message_chain(:social_networking_profile,
                                        :profile_answers,
                                        :where,
                                        :first!)
            post :update, id: 1

            assert_response 404
            expect(json["error"]).to eq "profile not found"
          end
        end

        context "profile answer is found" do
          before do
            allow(participant)
              .to receive_message_chain(:social_networking_profile,
                                        :profile_answers,
                                        :where,
                                        :first!) { answer }
          end

          context "update succeeds" do
            it "renders the serialized answer" do
              allow(answer).to receive(:update) { true }

              expect(Serializers::ProfileAnswerSerializer)
                .to receive_message_chain(:new, :to_serialized)

              post :update, id: 1
            end
          end

          context "update fails" do
            let(:errors) { double("errors", full_messages: ["epic fail"]) }

            it "renders error message" do
              allow(answer).to receive_messages(update: false, errors: errors)
              post :update, id: 1

              assert_response 400
              expect(json["error"]).to eq "epic fail"
            end
          end
        end
      end
    end
  end
end
