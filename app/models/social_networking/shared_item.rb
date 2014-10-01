module SocialNetworking
  # An item that a Participant has shared.
  class SharedItem < ActiveRecord::Base
    belongs_to :item, polymorphic: true
  end
end
