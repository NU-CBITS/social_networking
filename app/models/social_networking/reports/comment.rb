module SocialNetworking
  module Reports
    # Scenario: a Participant comments on a feed item.
    class Comment
      def self.columns
        %w( participant_id occurred_at item_type text )
      end

      def self.all
        Participant.select(:id, :study_id).map do |participant|
          ::SocialNetworking::Comment
            .where(participant_id: participant.id).map do |comment|
              item = (comment.item.try(:item) || comment.item)
              next if item.nil?

              {
                participant_id: participant.study_id,
                occurred_at: comment.created_at,
                item_type: item.class.to_s,
                text: comment.text
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
