require "spec_helper"

module SocialNetworking
  RSpec.describe Notification do
    let(:participant) { instance_double(Participant) }
    let(:recipient) { instance_double(Participant) }
    let(:mailer) { double("mailer") }

    def notification(attributes = {})
      Notification.new({
        current_participant: participant,
        mailer: mailer,
        recipient: recipient,
        message_body: "foo",
        subject: "bar"
      }.merge(attributes))
    end

    describe ".notify" do
      describe "when recipient is the current_participant" do
        it "returns nil" do
          new_notification = notification(recipient: participant)

          expect(new_notification.notify).to be_nil
        end
      end

      describe "when recipient is not the current_participant" do
        describe "when recipient would prefer to receive emails" do
          it "sends an email" do
            allow(recipient)
              .to receive(:contact_preference) { "email" }

            expect_any_instance_of(Notification)
              .to receive(:send_email)

            notification.notify
          end
        end

        describe "when recipient would prefer to receive sms" do
          it "sends an sms" do
            allow(recipient)
              .to receive(:contact_preference) { "sms" }

            expect_any_instance_of(Notification)
              .to receive(:send_sms)

            notification.notify
          end

          it "handles a Twilio SMS exception" do
            allow(recipient)
              .to receive(:contact_preference) { "sms" }

            expect_any_instance_of(Notification)
              .to receive(:send_sms)
                    .and_raise(Twilio::REST::RequestError.new("SMS error."))

            notification.notify
          end
        end
      end
    end
  end
end
