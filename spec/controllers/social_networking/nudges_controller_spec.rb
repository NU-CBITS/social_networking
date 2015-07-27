require "spec_helper"

module SocialNetworking
  describe NudgesController, type: :controller do
    describe "POST create" do
      context "when the participant is authenticated" do
        let(:nudge) { double("nudge", recipient_id: 1) }
        let(:participant) { double("participant", id: 1, display_name: "joe") }

        before do
          @routes = Engine.routes
          allow(controller).to receive(:current_participant) { participant }
          allow(Serializers::NudgeSerializer)
            .to receive_message_chain(:new, :to_serialized)
            .and_return(foo: :bar)
          allow(Nudge).to receive(:new) { nudge }
        end

        context "record saves" do
          let(:logger) { Rails.logger }

          def recipient(attributes = {})
            double("recipient", attributes)
          end

          before do
            allow(logger).to receive(:error)
            allow(logger).to receive(:info)
            allow(nudge).to receive(:save) { true }
          end

          describe "recipient has no contact preference" do
            it "should return serialized nudge" do
              allow(Participant).to receive(:find) do
                recipient(id: 1, contact_preference: nil)
              end

              expect(logger).to receive(:error)

              post :create

              assert_response 200
              expect(json["foo"]).to eq("bar")
            end
          end

          describe "recipient prefers to be contacted via phone" do
            it "should notify via phone" do
              allow(Participant).to receive(:find) do
                recipient(contact_preference: "phone", phone_number: "#")
              end

              expect(logger).to receive(:info)

              post :create
            end
          end

          describe "recipient prefers to be contacted via sms" do
            it "should notify via sms" do
              allow(Participant).to receive(:find) do
                recipient(contact_preference: "sms", phone_number: "#")
              end

              expect(logger).to receive(:info)

              post :create
            end
          end

          describe "recipient prefers to be contacted via email" do
            before do
              allow(Participant).to receive(:find) do
                recipient(contact_preference: "email", email: "mia@ex.co")
              end
              allow(NudgeMailer)
                .to receive_message_chain(:nudge_email_alert, :deliver)
            end

            it "sends an email alert with a default app name" do
              expect(NudgeMailer).to receive(:nudge_email_alert)
                .with(anything, anything, "You've been NUDGED on ThinkFeelDo")

              post :create
            end

            it "should notify via email alert with the localized app name" do
              allow(controller).to receive(:t).and_return("SunnySide")

              expect(NudgeMailer).to receive(:nudge_email_alert)
                .with(anything, anything, "You've been NUDGED on SunnySide")

              post :create
            end

            it "should contain email that redirects patient to their profile" do
              expect(NudgeMailer).to receive(:nudge_email_alert)
                .with(anything, %r{/social_networking/profile_page}, anything)

              post :create
            end
          end
        end

        context "record doesn't save" do
          let(:errors) { double("errors", full_messages: ["baz"]) }

          it "should return the error message" do
            allow(nudge).to receive_messages(save: false, errors: errors)
            post :create

            assert_response 400
            expect(json["error"]).to eq("baz")
          end
        end
      end
    end
  end
end
