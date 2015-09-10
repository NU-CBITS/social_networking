module SocialNetworking
  # Sends sms or emails to participants.
  class Notification
    include Sms
    attr_reader :current_participant,
                :mailer,
                :recipient,
                :message_body,
                :subject

    def initialize(
      current_participant:,
      mailer:,
      recipient:,
      message_body:,
      subject:)
      @current_participant = current_participant
      @mailer = mailer
      @message_body = message_body
      @recipient = recipient
      @subject = subject
    end

    def notify
      return if current_participant == recipient
      if recipient.contact_preference == "email"
        send_email
      else
        send_sms(recipient, message_body)
      end
    end

    def send_email
      mailer
        .notify(
          recipient: recipient,
          body: message_body,
          subject: subject)
        .deliver
    end
  end
end
