# NudgeMailer is used to notify recipients of nudges via email.
class NudgeMailer < ActionMailer::Base
  def nudge_email_alert(receiving_participant, message_body, subject = nil)
    @message_body = message_body
    subject = subject.nil? ? message_body : subject
    mail(to: receiving_participant.email, subject: subject).deliver
  end
end
