module SocialNetworking
  # A statement by a Participant to be shared with the Group.
  class OnTheMindStatement < ActiveRecord::Base
    belongs_to :participant

    validates :participant, :description, presence: true
  end
end
