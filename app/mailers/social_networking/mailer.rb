# frozen_string_literal: true
module SocialNetworking
  # Notifies participants of comments, likes, and nudges.
  class Mailer < ActionMailer::Base
    def notify(recipient:, body:, subject:)
      @message_body = body
      mail(to: recipient.email, subject: subject)
    end
  end
end
