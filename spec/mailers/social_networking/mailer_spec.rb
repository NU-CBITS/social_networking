require "spec_helper"

module SocialNetworking
  describe Mailer do
    describe ".notify" do
      let(:recipient) { instance_double(Participant, email: "obama@ex.co") }

      describe "When subject and body exist" do
        let(:mail) do
          Mailer.notify(
            recipient: recipient,
            body: "body",
            subject: "subject")
        end

        it "delivers mail with a subject" do
          expect(mail.subject).to eq "subject"
        end

        it "delivers the body" do
          expect(mail.body).to match "body"
        end
      end
    end
  end
end
