module SocialNetworking
  # Allows for shareable items to be passed in to evaluate properties
  class Shareable
    def initialize(item = nil)
      @item = item
    end

    def action
      @item.try(:action) || "Shared"
    end
  end
end
