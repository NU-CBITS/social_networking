require "spec_helper"

module SocialNetworking
  describe NudgesController, type: :controller do
    describe "POST create" do
      context "when the participant is authenticated" do
        let(:participant) do
          double("participant",
                 id: 987,
                 contact_preference: "sms",
                 phone_number: "16309101110",
                 email: "test@tester.com",
                 display_name: "hamburger")
        end
        let(:nudge) do
          double("nudge",
                 id: 8_675_309,
                 created_at: DateTime.new,
                 initiator_id: participant.id,
                 recipient_id: 123,
                 comments: [])
        end
        let(:receiver) do
          double(
            "receiver",
            id: 123,
            email: "test@tester.com",
            contact_preference: "email",
            phone_number: "16309201110"
          )
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
          allow(nudge).to receive(:save) { true }
          allow(Participant).to receive(:find) { participant }
          allow(controller).to receive(:send_sms) { nil }
        end

        context "and the record saves" do
          before do
            allow(nudge).to receive(:save) { true }
            allow(Participant).to receive(:find) { receiver }
            allow(controller).to receive(:send_sms) { nil }
          end

          it "should return the new record" do
            expect(NudgeMailer).to receive(:nudge_email_alert)
              .with(receiver, /.*[social_networking\/home]/, /.*/)
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
