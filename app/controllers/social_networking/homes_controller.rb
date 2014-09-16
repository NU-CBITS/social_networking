module SocialNetworking
  # Provide Participant home page tools.
  class HomesController < ApplicationController
    def show
      @feed_items = Serializers::OnTheMindStatementSerializer
        .from_collection(OnTheMindStatement.all)
      @member_profiles = []
    end
  end
end
