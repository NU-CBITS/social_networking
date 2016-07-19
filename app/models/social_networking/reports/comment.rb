# frozen_string_literal: true
module SocialNetworking
  module Reports
    # Scenario: a Participant comments on a feed item.
    class Comment
      def self.columns
        %w( participant_id occurred_at item_type text item_participant_id
            item_content )
      end

      def self.all
        Participant.select(:id, :study_id).map do |participant|
          ::SocialNetworking::Comment
            .where(participant_id: participant.id).map do |comment|
              item = (comment.item.try(:item) || comment.item)
              next if item.nil?
              item_participant = Participant
                                 .find_by_id(item.try(:participant_id))

              {
                participant_id: participant.study_id,
                occurred_at: comment.created_at.iso8601,
                item_type: item.class.to_s,
                text: comment.text,
                item_participant_id: item_participant.try(:study_id),
                item_content: comment.item_description
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
