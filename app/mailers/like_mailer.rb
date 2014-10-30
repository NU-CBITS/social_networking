# LikeMailer is used to notify recipients of like applied to their shared items.
class LikeMailer < ActionMailer::Base
  # TODO: set from address in application properties
  default from: "social_networking@northwestern.edu"

  # Send trigger an email that alerts an item's creator of a like.
  def like_email_alert(receiving_participant, message_body, *subject)
    @message_body = message_body
    if subject.nil?
      subject = message_body
    end
    mail(to: receiving_participant.email, subject: subject)
  end
end
