require "spec_helper"

describe LikeMailer do
  describe ".like_email_alert" do
    let(:receiving_participant) { double("participant", email: "obama@ex.co") }

    it "delivers mail with a subject" do
      mail = LikeMailer.like_email_alert(
        receiving_participant,
        "Supreme court decision was something else!",
        "Health Care"
      )

      expect(mail.subject).to eq "Health Care"
    end

    it "subject defaults to body when no subject is provided" do
      mail = LikeMailer.like_email_alert(
        receiving_participant,
        "Supreme court decision was something else!"
      )

      expect(mail.subject).to eq "Supreme court decision was something else!"
    end

    it "delivers mail with body" do
      mail = LikeMailer.like_email_alert(
        receiving_participant,
        "Supreme court decision was something else!",
        "Health Care"
      )

      expect(mail.body).to match "Supreme court decision was something else!"
    end
  end
end
