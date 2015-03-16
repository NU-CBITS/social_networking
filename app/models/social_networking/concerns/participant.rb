module SocialNetworking
  module Concerns
    # adds associations to Participant class
    module Participant
      extend ActiveSupport::Concern
      included do
        has_many :social_networking_comments,
                 class_name: "SocialNetworking::Comment",
                 dependent: :destroy
        has_many :social_networking_goals,
                 class_name: "SocialNetworking::Goal",
                 dependent: :destroy
        has_many :social_networking_likes,
                 class_name: "SocialNetworking::Like",
                 dependent: :destroy
        has_many :initiator_nudges,
                 foreign_key: :initiator_id,
                 class_name: "SocialNetworking::Nudge",
                 dependent: :destroy
        has_many :recipient_nudges,
                 foreign_key: :recipient_id,
                 class_name: "SocialNetworking::Nudge",
                 dependent: :destroy
        has_many :social_networking_on_the_mind_statements,
                 class_name: "SocialNetworking::OnTheMindStatement",
                 dependent: :destroy
        has_one :social_networking_profile,
                class_name: "SocialNetworking::Profile",
                dependent: :destroy
      end
    end
  end
end
