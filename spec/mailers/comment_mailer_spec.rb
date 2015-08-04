require "spec_helper"

describe CommentMailer do
  describe ".comment_email_alert" do
    let(:receiving_participant) { double("participant", email: "obama@ex.co") }

    it "delivers mail with a subject" do
      mail = CommentMailer.comment_email_alert(
        receiving_participant,
        "Supreme court decision was something else!",
        "Health Care"
      )

      expect(mail.subject).to eq "Health Care"
    end

    it "subject defaults to body when no subject is provided" do
      mail = CommentMailer.comment_email_alert(
        receiving_participant,
        "Supreme court decision was something else!"
      )

      expect(mail.subject).to eq "Supreme court decision was something else!"
    end

    it "delivers mail with body" do
      mail = CommentMailer.comment_email_alert(
        receiving_participant,
        "Supreme court decision was something else!",
        "Health Care"
      )

      expect(mail.body).to match "Supreme court decision was something else!"
    end
  end
end
