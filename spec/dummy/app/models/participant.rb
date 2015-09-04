class Participant < ActiveRecord::Base
  include SocialNetworking::Concerns::Participant

  attr_reader :navigation_status

  def active_membership_end_date
    Date.today.advance(weeks: 8)
  end

  def active_group
    self
  end

  def active_participants
    Participant.all
  end

  def display_name
    "display name"
  end

  def latest_action_at
    DateTime.new
  end

  def is_admin
    true
  end

  def current_group
    self
  end

  def arm
    Arm.new
  end

  def study_id
    "participant_study_id"
  end
end
