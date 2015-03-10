module SocialNetworking
  module Reports
    # Scenario: a Participant has a Goal.
    class Goal
      def self.columns
        %w( participant_id created_at is_completed description )
      end

      def self.all
        Participant.select(:id, :study_id).map do |participant|
          ::SocialNetworking::Goal
          .where(participant_id: participant.id).map do |goal|
            {
              participant_id: participant.study_id,
              created_at: goal.created_at,
              is_completed: goal.is_completed,
              description: goal.description
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
