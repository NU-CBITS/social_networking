require "spec_helper"

module SocialNetworking
  class Participant; end

  describe ParticipantsController, type: :controller do
    describe "GET index" do
      context "when the participant is authenticated" do
        let(:participant) do
          double("participant",
                 id: 987,
                 email: "foo@bar.com",
                 last_sign_in_at: "2014-04-29T15:39:04.244-05:00")
        end

        before do
          allow(controller).to receive(:authenticate_participant!)
          allow(Participant).to receive(:all) { [participant] }
        end

        it "should return the participants" do
          get :index, use_route: :social_networking

          assert_response 200
          expect(json.count).to eq(1)
          expect(json[0]["id"]).to eq(987)
        end
      end
    end
  end
end
