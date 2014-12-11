module SocialNetworking
  # Something to be completed by a Participant.
  class Goal < ActiveRecord::Base
    ACTION_TYPES = %w( created completed )
    Actions = Struct.new(*ACTION_TYPES.map(&:to_sym)).new(*ACTION_TYPES)

    belongs_to :participant
    has_many :comments, as: "item"
    has_many :likes, as: "item"

    validates :participant, :description, presence: true
    validates :is_completed, :is_deleted, inclusion: { in: [true, false] }
    validate :not_due_in_the_past, on: :create
    validate :due_before_membership_ends, on: :create

    def to_serialized
      if due_on
      {
        description: description,
        dueOn: due_on,
        dueOnDisplay: due_on ? due_on.strftime("%b. %e, %Y at %l:%M%p") : ""
      }
      else
        {}
      end
    end

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
