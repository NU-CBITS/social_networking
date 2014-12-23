# LikeMailer is used to notify recipients of like applied to their shared items.
class LikeMailer < ActionMailer::Base
  # Send trigger an email that alerts an item's creator of a like.
  def like_email_alert(receiving_participant, message_body, *subject)
    @message_body = message_body
    subject = subject.nil? ? message_body : subject
    mail(to: receiving_participant.email, subject: subject).deliver
  end
end
