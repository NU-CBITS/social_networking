require_dependency "social_networking/application_controller"

module SocialNetworking
  # Provide Participant home page tools.
  class HomesController < ApplicationController
    include Concerns::ShowFeed

    def show
      render locals: feed_data_for(current_participant, self)
    end
  end
end
