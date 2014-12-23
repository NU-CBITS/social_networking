# CommentMailer is used to notify recipients of comments via email.
class CommentMailer < ActionMailer::Base
  def comment_email_alert(receiving_participant, message_body, *subject)
    logger.info("INFO BEFORE: Comment email notification sent \
to:" + receiving_participant.email)
    @message_body = message_body
    subject = subject.nil? ? message_body : subject
    mail(to: receiving_participant.email, subject: subject).deliver
    logger.info("INFO AFTER: Comment email notification sent \
to:" + receiving_participant.email)
  end
end
