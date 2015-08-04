# NudgeMailer is used to notify recipients of nudges via email.
class NudgeMailer < ActionMailer::Base
  def nudge_email_alert(receiving_participant, message_body, *subject)
    logger.info("INFO BEFORE: Nudge email notification sent \
                 to:" + receiving_participant.email)
    @message_body = message_body
    subject = subject.empty? ? message_body : subject
    mail(to: receiving_participant.email, subject: subject).deliver
    logger.info("INFO AFTER: Nudge email notification sent \
                 to:" + receiving_participant.email)
  end
end
