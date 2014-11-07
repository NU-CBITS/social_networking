module SocialNetworking
  # A comment written by a Participant and attached to a piece of content.
  class Comment < ActiveRecord::Base
    belongs_to :participant
    belongs_to :item, polymorphic: true

    validates :participant, :item, :text, presence: true
  end
end

