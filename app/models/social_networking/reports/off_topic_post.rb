module SocialNetworking
  module Reports
    # Scenario: a Participant creates an off topic post.
    class OffTopicPost
      def self.columns
        %w( participant_id occurred_at description )
      end

      def self.all
        Participant.select(:id, :study_id).map do |participant|
          ::SocialNetworking::OnTheMindStatement
            .where(participant_id: participant.id).map do |post|
              {
                participant_id: participant.study_id,
                occurred_at: post.created_at.iso8601,
                description: post.description
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
