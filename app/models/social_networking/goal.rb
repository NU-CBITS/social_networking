module SocialNetworking
  # Something to be completed by a Participant.
  class Goal < ActiveRecord::Base
    belongs_to :participant

    validates :participant, :description, presence: true
    validates :is_completed, :is_deleted, inclusion: { in: [true, false] }
    validate :not_due_in_the_past, on: :create
    validate :due_before_membership_ends, on: :create

    private

    def not_due_in_the_past
      return if due_on.nil? || due_on >= Date.today

      errors.add :due_on, "must not be in the past"
    end

    def due_before_membership_ends
      return if due_on.nil? ||
                participant_id.nil? ||
                participant.active_membership_end_date.nil? ||
                due_on <= participant.active_membership_end_date

      errors.add :due_on, "must be during study enrollment"
    end
  end
end
