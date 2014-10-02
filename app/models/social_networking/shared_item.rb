module SocialNetworking
  # An item that a Participant has shared.
  class SharedItem < ActiveRecord::Base
    belongs_to :item, polymorphic: true
    has_many :comments, as: "item"
  end
end
