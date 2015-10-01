module SocialNetworking
  module Concerns
    module ProfilePage
      # Displays feed data for profile page.
      class Feed
        attr_reader :participant_id, :page
        SHARED_ITEM_PAGE_SIZE = 5

        def initialize(participant_id:, page:)
          @participant_id = participant_id
          @page = page.try(:to_i) || 0
        end

        def page_items
          if feed_items_page.size >= start_index
            feed_items[start_index..(start_index + SHARED_ITEM_PAGE_SIZE - 1)]
          else
            []
          end
        end

        private

        def feed_items_page
          on_the_mind_statements + nudges + shared_items
        end

        def feed_items
          feed_items_page.sort_by { |item| item[:createdAtRaw] }.reverse!
        end

        def start_index
          page * SHARED_ITEM_PAGE_SIZE
        end

        def nudges
          Serializers::NudgeSerializer
            .from_collection(
              Nudge
                .where(initiator_id: participant_id)
                .order(created_at: :desc)
                .limit(SHARED_ITEM_PAGE_SIZE * (page + 1))
                .includes(:comments))
        end

        def on_the_mind_statements
          Serializers::OnTheMindStatementSerializer
            .from_collection(
              OnTheMindStatement
                .where(participant_id: participant_id)
                .order(created_at: :desc)
                .limit(SHARED_ITEM_PAGE_SIZE * (page + 1))
                .includes(:comments, :likes))
        end

        def shared_items
          Serializers::SharedItemSerializer
            .from_collection(
              SharedItem
                .includes(:item, :comments)
                .joins(:participant)
                .where(participant_id: participant_id)
                .order(created_at: :desc)
                .limit(SHARED_ITEM_PAGE_SIZE * (page + 1))
            )
        end
      end
    end
  end
end
