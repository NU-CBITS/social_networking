# NudgeMailer is used to notify recipients of nudges via email.
class NudgeMailer < ActionMailer::Base
  # TODO: set from address in application properties
  default from: "social_networking@northwestern.edu"


  def nudge_email_alert(receiving_participant, message_body, *subject)
    @message_body = message_body
    if subject.nil?
      subject = message_body
    end
    mail(to: receiving_participant.email, subject: subject)
  end
end
