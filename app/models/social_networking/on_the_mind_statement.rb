module SocialNetworking
  # A statement by a Participant to be shared with the Group.
  class OnTheMindStatement < ActiveRecord::Base
    belongs_to :participant
    has_many :comments, as: "item"

    validates :participant, :description, presence: true
  end
end
