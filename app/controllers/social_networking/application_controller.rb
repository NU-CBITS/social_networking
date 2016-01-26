module SocialNetworking
  # Top level engine controller
  # Inherits from host's ApplicationController.
  class ApplicationController < ::ApplicationController
    CSRF_COOKIE_NAME = "XSRF-TOKEN"
    CSRF_HEADER_NAME = "X-XSRF-TOKEN"

    before_action :authenticate_participant!
    after_action :set_csrf_cookie_for_ng

    layout "tool"

    protected

    def verified_request?
      super ||
        valid_authenticity_token?(session, request.headers[CSRF_HEADER_NAME])
    end

    private

    def set_csrf_cookie_for_ng
      return unless protect_against_forgery?
      cookies[CSRF_COOKIE_NAME] = form_authenticity_token
    end
  end
end
