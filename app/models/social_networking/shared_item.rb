module SocialNetworking
  # An item that a Participant has shared.
  class SharedItem < ActiveRecord::Base
    self.abstract_class = true

    belongs_to :participant

    validates :participant, presence: true
  end
end
