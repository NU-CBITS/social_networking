module SocialNetworking
  # Provide Participant home page tools.
  class HomesController < ApplicationController
    def show
      @feed_items =
        OnTheMindStatement.where(participant_id: current_participant.id)
      @member_profiles = []
    end
  end
end
