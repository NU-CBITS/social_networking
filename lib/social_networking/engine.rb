# frozen_string_literal: true
require "rubygems"
require "twilio-ruby"

module SocialNetworking
  # Mountable engine with isolated namespace.
  class Engine < ::Rails::Engine
    isolate_namespace SocialNetworking

    config.generators do |g|
      g.test_framework :rspec
      g.assets false
      g.helper false
    end

    config.action_mailer.default_url_options =
      { host: "moodtech-no-reply@northwestern.edu" }
    config.action_mailer.default_options =
      { from: "moodtech-no-reply@northwestern.edu" }

    config.twilio_account_sid =
      ENV["MOODCONNECT_TWILIO_ACCOUNT_SID"]
    config.twilio_auth_token =
      ENV["MOODCONNECT_TWILIO_AUTH_TOKEN"]
    config.twilio_account_telephone_number =
      ENV["MOODCONNECT_TWILIO_PHONE_NUMBER"]

    config.enable_notices = false
  end
end
