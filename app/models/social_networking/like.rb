module SocialNetworking
  class Like < ActiveRecord::Base
    belongs_to :participant
    belongs_to :item, polymorphic: true

    validates :participant, :item, presence: true
  end
end
