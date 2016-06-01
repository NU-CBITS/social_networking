# frozen_string_literal: true
module SocialNetworking
  module Concerns
    # Rescues exception when authenticity token has expired
    module InvalidAuthToken
      extend ActiveSupport::Concern

      included do
        rescue_from ActionController::InvalidAuthenticityToken,
                    with: :invalid_auth_token_redirect
      end

      private

      def invalid_auth_token_redirect
        redirect_to "/",
                    alert: "Your authenticity token expired. "\
                           "Please try again."
      end
    end
  end
end
