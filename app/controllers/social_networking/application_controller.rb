module SocialNetworking
  # Top level controller.
  class ApplicationController < ActionController::Base
    before_action :authenticate_participant!
  end
end
