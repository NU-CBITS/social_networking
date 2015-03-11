module SocialNetworking
  # An item that a Participant has shared.
  class SharedItem < ActiveRecord::Base
    before_save :default_creator, :set_action_type

    belongs_to :item, polymorphic: true
    has_many :comments, as: "item"
    has_many :likes, as: "item"

    private

    def default_creator
      self.participant_id = item.participant_id
    end

    def set_action_type
      self.action_type = Shareable.new(item).action
    end
  end
end
