module SocialNetworking
  # Something to be completed by a Participant.
  class Goal < ActiveRecord::Base
    belongs_to :participant

    validates :participant, :description, presence: true
  end
end
