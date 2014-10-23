# NudgeMailer is used to notify recipients of nudges via email.
class NudgeMailer < ActionMailer::Base
  # TODO: set from address in application properties
  default from: "social_networking@northwestern.edu"

  def nudge_email_alert(receiving_participant, sender_participant)
    @receiving_participant = receiving_participant
    @sender_participant = sender_participant
    @url = root_url
    mail(to: @receiving_participant.email, subject: "You were nudged!")
  end
end
