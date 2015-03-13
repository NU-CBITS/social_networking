module SocialNetworking
  module Reports
    # Scenario: a Participant likes a feed item.
    class Like
      def self.columns
        %w( participant_id occurred_at item_type item_content)
      end

      def self.all
        Participant.select(:id, :study_id).map do |participant|
          ::SocialNetworking::Like
            .where(participant_id: participant.id).map do |like|
              item = (like.item.try(:item) || like.item)
              next if item.nil?

              {
                participant_id: participant.study_id,
                created_at: like.created_at,
                item_type: item.class.to_s,
                item_content: like.item_description
              }
            end
        end.flatten.compact
      end

      def self.to_csv
        ThinkFeelDoEngine::Reports::Reporter.new(self).write_csv
      end
    end
  end
end
