module SocialNetworking
  # Top level controller.
  class ApplicationController < ::ApplicationController
    before_action :authenticate_participant!
    after_action :set_csrf_cookie_for_ng

    protected

    def verified_request?
      super || form_authenticity_token == request.headers["X-XSRF-TOKEN"]
    end

    private

    def set_csrf_cookie_for_ng
      return unless protect_against_forgery?
      cookies["XSRF-TOKEN"] = form_authenticity_token
    end
  end
end
