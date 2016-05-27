# frozen_string_literal: true
module SocialNetworking
  # A helper for aggregating "todo" items.
  class ActionItem
    class << self
      attr_writer :source_class_name

      def for(participant)
        return [] if @source_class_name.nil?

        @source_class_name.constantize.for(participant)
      end
    end
  end
end
