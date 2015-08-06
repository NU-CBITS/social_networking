# CommentMailer is used to notify recipients of comments via email.
class CommentMailer < ActionMailer::Base
  def comment_email_alert(receiving_participant, message_body, subject = nil)
    @message_body = message_body
    subject = subject.nil? ? message_body : subject
    mail(to: receiving_participant.email, subject: subject).deliver
  end
end
