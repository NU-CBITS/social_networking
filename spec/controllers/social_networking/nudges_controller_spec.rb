require "spec_helper"

module SocialNetworking
  describe NudgesController, type: :controller do
    describe "POST create" do
      context "when the participant is authenticated" do
        let(:nudge) { double("nudge", recipient_id: 1) }
        let(:participant) { double("participant", id: 1, display_name: "joe") }

        def recipient(attributes = {})
          double("recipient", { id: 1, contact_preference: nil }
            .merge(attributes))
        end

        before do
          @routes = Engine.routes
          allow(controller).to receive(:current_participant) { participant }
          allow(Serializers::NudgeSerializer)
            .to receive_message_chain(:new, :to_serialized)
            .and_return(foo: :bar)
          allow(Nudge).to receive(:new) { nudge }
        end

        context "nudge saves and notification is sent" do
          before do
            allow(nudge).to receive(:save) { true }
          end

          after do
            assert_response 200
            expect(json["message"]).to eq "Nudge sent!"
          end

          describe "recipient prefers to be contacted via phone" do
            it "should notify via phone" do
              allow(Participant).to receive(:find) do
                recipient(contact_preference: "phone", phone_number: "#")
              end

              expect(controller).to receive(:send_sms)

              post :create
            end
          end

          describe "recipient prefers to be contacted via sms" do
            it "should notify via sms" do
              allow(Participant).to receive(:find) do
                recipient(contact_preference: "sms", phone_number: "#")
              end

              expect(controller).to receive(:send_sms)

              post :create
            end
          end

          describe "recipient prefers to be contacted via email" do
            before do
              allow(Participant).to receive(:find) do
                recipient(contact_preference: "email", email: "mia@ex.co")
              end
              allow(Mailer)
                .to receive_message_chain(:notify, :deliver)
            end

            it "sends an email alert with a default app name" do
              expect(Mailer).to receive(:notify)
                .with(
                  recipient: anything,
                  body: anything,
                  subject: "You've been NUDGED on ThinkFeelDo")

              post :create
            end

            it "should notify via email alert with the localized app name" do
              allow(controller).to receive(:t).and_return("SunnySide")

              expect(Mailer).to receive(:notify)
                .with(
                  recipient: anything,
                  body: anything,
                  subject: "You've been NUDGED on SunnySide")

              post :create
            end

            it "should contain email that redirects patient to their profile" do
              expect(Mailer).to receive(:notify)
                .with(
                  recipient: anything,
                  body: %r{/social_networking/profile_page},
                  subject: anything)

              post :create
            end
          end
        end

        context "record doesn't save" do
          let(:errors) { double("errors", full_messages: ["baz"]) }

          it "returns the error message" do
            allow(Participant).to receive(:find) do
              recipient(contact_preference: "email", email: "mia@ex.co")
            end
            allow(nudge).to receive_messages(save: false, errors: errors)
            post :create

            assert_response 400
            expect(json["error"]).to eq "baz"
          end
        end
      end
    end
  end
end
