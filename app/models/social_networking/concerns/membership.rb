# frozen_string_literal: true
module SocialNetworking
  module Concerns
    # adds scops to Membership class
    module Membership
      extend ActiveSupport::Concern
      def comments
        SocialNetworking::Comment.where(participant: participant)
      end

      def likes
        SocialNetworking::Like.where(participant: participant)
      end

      def nudges
        SocialNetworking::Nudge.where(initiator_id: participant)
      end

      def goals
        SocialNetworking::Goal.where(participant: participant)
      end

      def on_the_minds
        SocialNetworking::OnTheMindStatement.where(participant: participant)
      end
    end
  end
end
