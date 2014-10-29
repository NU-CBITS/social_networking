# LikeMailer is used to notify recipients of like applied to their shared items.
class LikeMailer < ActionMailer::Base
  # TODO: set from address in application properties
  default from: "social_networking@northwestern.edu"

  def like_email_alert(receiving_participant, sender_participant, message_body)
    @receiving_participant = receiving_participant
    @sender_participant = sender_participant
    @message_body = message_body
    mail(to: @receiving_participant.email, subject: message_body)
  end
end
