module SocialNetworking
  module Reports
    # Scenario: a Participant nudges another Participant.
    class Nudge
      def self.columns
        %w( participant_id occurred_at recipient_id )
      end

      def self.all
        Participant.select(:id, :study_id).map do |participant|
          ::SocialNetworking::Nudge
            .where(initiator_id: participant.id).map do |nudge|
              {
                participant_id: participant.study_id,
                occurred_at: nudge.created_at.iso8601,
                recipient_id: nudge.recipient.study_id
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
