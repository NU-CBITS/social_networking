module SocialNetworking
  # An item that a Participant has shared.
  class SharedItem < ActiveRecord::Base
    before_save :default_creator

    belongs_to :item, polymorphic: true
    has_many :comments, as: "item"
    has_many :likes, as: "item"

    def default_creator
      self.participant_id = item.participant_id
    end
  end
end
