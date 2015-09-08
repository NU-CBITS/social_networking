require "spec_helper"

module SocialNetworking
  describe NudgesController, type: :controller do
    describe "POST create" do
      context "when the participant is authenticated" do
        let(:nudge) { instance_double(Nudge, recipient_id: 1) }
        let(:participant) do
          instance_double(
            Participant,
            id: 1,
            display_name: "joe")
        end

        def recipient(attributes = {})
          instance_double(
            Participant, {
              id: 1,
              contact_preference: nil
            }.merge(attributes))
        end

        before do
          @routes = Engine.routes
          allow(controller).to receive(:current_participant) { participant }
          allow(Nudge).to receive(:new) { nudge }
        end

        context "the record saves" do
          before do
            allow(nudge).to receive(:save) { true }
          end

          after do
            assert_response 200
            expect(json["message"]).to eq "Nudge sent!"
          end

          describe "recipient prefers to be contacted via phone" do
            it "should notify via phone" do
              allow(Participant)
                .to receive(:find)
                .and_return(recipient(contact_preference: "phone"))

              expect_any_instance_of(Notification)
                .to receive(:notify)

              post :create
            end
          end

          describe "recipient prefers to be contacted via sms" do
            it "should notify via sms" do
              allow(Participant)
                .to receive(:find)
                .and_return(recipient(contact_preference: "sms"))

              expect_any_instance_of(Notification)
                .to receive(:notify)

              post :create
            end
          end

          describe "recipient prefers to be contacted via email" do
            let(:recipient_with_eamil) do
              recipient(contact_preference: "email")
            end
            let(:notication) { instance_double(Notification) }

            before do
              allow(controller).to receive(:t) { "SunnySide" }
              allow(Participant).to receive(:find) { recipient_with_eamil }
              allow(notication).to receive(:notify)
              allow(Notification).to receive(:new) { notication }
            end

            it "should notify via email with link and text 'SunnySide'" do
              expect(Notification)
                .to receive(:new)
                .with(
                  current_participant: participant,
                  mailer: Mailer,
                  recipient: recipient_with_eamil,
                  message_body: %r{/social_networking/profile_page},
                  subject: "You've been NUDGED on SunnySide")
              expect(notication).to receive(:notify)

              post :create
            end
          end
        end

        context "record doesn't save" do
          let(:errors) { double("errors", full_messages: ["baz"]) }

          it "returns an error message" do
            allow(Participant).to receive(:find)
            allow(nudge)
              .to receive_messages(save: false, errors: errors)

            post :create

            assert_response 400
            expect(json["error"]).to eq "baz"
          end
        end
      end
    end
  end
end
