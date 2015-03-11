module SocialNetworking
  # Allows for shareable items to be passed in to evaluate properties
  class Shareable
    def initialize(item = nil)
      @item = item
    end

    def action
      @item.try(:action) || "Shared"
    end

    def description
      @item.try(:shared_description) || "Description not available for this item."
    end
  end
end
