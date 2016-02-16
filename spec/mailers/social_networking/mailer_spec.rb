require "spec_helper"

module SocialNetworking
  describe Mailer do
    describe ".notify" do
      let(:recipient) { instance_double(Participant, email: "obama@ex.co") }

      it "delivers an email" do
        expect do
          Mailer
            .notify(
              recipient: recipient,
              body: "foo",
              subject: "bar")
            .deliver_now
        end.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end
  end
end
