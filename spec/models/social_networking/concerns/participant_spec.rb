# frozen_string_literal: true
require "spec_helper"

module SocialNetworking
  module Concerns
    RSpec.describe Participant do
      describe "validations" do
        context "contact preference is selected" do
          it "is invalid if email is not provided" do
            expect(::Participant
              .new(contact_preference: "email")
              .tap(&:valid?)
              .errors[:email]).to include "can't be blank"
          end

          it "is invalid if phone number is not provided" do
            expect(::Participant
              .new(contact_preference: "sms")
              .tap(&:valid?)
              .errors[:phone_number]).to include "can't be blank"
          end

          it "is invalid if phone number is not provided" do
            expect(::Participant
              .new(contact_preference: "phone")
              .tap(&:valid?)
              .errors[:phone_number]).to include "can't be blank"
          end
        end
      end
    end
  end
end
