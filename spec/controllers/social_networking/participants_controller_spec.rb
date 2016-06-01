# frozen_string_literal: true
require "spec_helper"

module SocialNetworking
  describe ParticipantsController, type: :controller do
    let(:participant) do
      double("participant",
             id: 987,
             email: "foo@bar.com",
             latest_action_at: "2014-04-29T15:39:04.244-05:00",
             active_membership_end_date: nil)
    end

    before(:each) { @routes = Engine.routes }

    describe "GET index" do
      context "when the current participant is authenticated" do
        before do
          allow(controller).to receive(:authenticate_participant!)
          allow(Participant).to receive(:all) { [participant] }
        end

        it "should return the participants" do
          get :index

          assert_response 200
          expect(json.count).to eq(1)
          expect(json[0]["id"]).to eq(987)
        end
      end
    end

    describe "GET show" do
      context "when the current participant is authenticated" do
        before do
          allow(controller).to receive(:authenticate_participant!)
        end

        context "and the participant is found" do
          before do
            allow(Participant).to receive(:find).with("987") { participant }
          end

          it "should return the participant" do
            get :show, id: 987

            assert_response 200
            expect(json["id"]).to eq(987)
          end
        end

        context "and the participant is not found" do
          before do
            allow(Participant).to receive(:find)
              .and_raise(ActiveRecord::RecordNotFound)
          end

          it "should return the participant" do
            get :show, id: 987

            assert_response 404
            expect(json["error"]).to eq("participant not found")
          end
        end
      end
    end
  end
end
