require_dependency "social_networking/application_controller"

module SocialNetworking
  # Sends back static templates.
  class TemplatesController < ApplicationController
    # Renders either the engine template if it exists or the host template.
    def page
      @path = params[:path].gsub(/[^_a-z\/]+/m, "")
      template = "social_networking/templates/#{ @path }.html"

      render file: template, layout: nil
    end
  end
end
