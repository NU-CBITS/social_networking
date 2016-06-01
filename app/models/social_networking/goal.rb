# frozen_string_literal: true
module SocialNetworking
  # Something to be completed by a Participant.
  class Goal < ActiveRecord::Base
    # create a mini DSL for types of Goal actions
    ACTION_TYPES = %w( created completed did_not_complete ).freeze
    Actions = Struct.new(*ACTION_TYPES.map(&:to_sym))
                    .new(*(ACTION_TYPES.map { |t| t.tr("_", " ") }))

    belongs_to :participant
    has_many :comments, as: "item"
    has_many :likes, as: "item"

    validates :participant, :description, presence: true
    validate :not_due_in_the_past, on: :create
    validate :due_before_membership_ends, on: :create

    # Within the last day, used for shared item generation
    scope :did_not_complete, (lambda do
      where(deleted_at: nil, completed_at: nil)
      .where(arel_table[:due_on].lt(Time.zone.today))
      .where(arel_table[:due_on].gteq(Time.zone.today - 1.day))
    end)

    def to_serialized
      if due_on
        {
          description: description,
          dueOn: due_on.to_s(:participant_date)
        }
      else
        {}
      end
    end

    def shared_description
      "Goal: #{description}"
    end

    # Necessary for legacy front-end code.
    # rubocop:disable Style/PredicateName
    def is_completed
      completed_at?
    end
    # rubocop:enable Style/PredicateName

    # Necessary for legacy front-end code.
    # rubocop:disable Style/PredicateName
    def is_deleted
      deleted_at?
    end
    # rubocop:enable Style/PredicateName

    def action
      if is_completed
        "Completed"
      elsif due_on && due_on < Time.zone.today
        "Did Not Complete"
      else
        "Created"
      end
    end

    private

    def not_due_in_the_past
      return if due_on.nil? || due_on >= Time.zone.today

      errors.add :due_on, "must not be in the past"
    end

    def due_before_membership_ends
      return if due_on.nil? ||
                participant_id.nil? ||
                participant.active_membership_end_date.nil? ||
                due_on <= participant.active_membership_end_date

      errors.add :due_on, "must be during study enrollment"
    end

    scope :for_today, lambda {
      where(arel_table[:created_at]
                .gteq(Time.zone.today.beginning_of_day)
                .and(arel_table[:created_at].lteq(Time.zone.today.end_of_day)))
    }

    scope :for_week, lambda {
      where(arel_table[:created_at]
             .gteq(Time.current.advance(days: -7).beginning_of_day))
    }
  end
end
