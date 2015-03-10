module SocialNetworking
  module Reports
    # Scenario: a Participant shares data from a tool.
    class ToolShare
      def self.columns
        %w( participant_id item_type shared_at )
      end
      
      def self.all
        Participant.select(:id, :study_id).map do |participant|
          ::SocialNetworking::SharedItem
          .where(participant_id: participant.id, is_public: true).map do |item|
            {
              participant_id: participant.study_id,
              item_type: item.item_type,
              shared_at: item.created_at
            }
          end
        end.flatten
      end

      def self.to_csv
        ThinkFeelDoEngine::Reports::Reporter.new(self).write_csv
      end
    end
  end
end
