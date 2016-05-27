# frozen_string_literal: true
module SocialNetworking
  module Reports
    # Scenario: a Participant has a Goal.
    class Goal
      # rubocop:disable Metrics/LineLength
      def self.columns
        %w( participant_id created_at due_on is_completed is_deleted description )
      end
      # rubocop:enable Metrics/LineLength

      def self.all
        Participant.select(:id, :study_id).map do |participant|
          ::SocialNetworking::Goal
            .where(participant_id: participant.id).map do |goal|
              {
                participant_id: participant.study_id,
                created_at: goal.created_at.iso8601,
                due_on: goal.due_on ? goal.due_on.iso8601 : "",
                is_completed: goal.is_completed,
                is_deleted: goal.is_deleted,
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
