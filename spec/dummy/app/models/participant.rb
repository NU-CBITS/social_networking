class Participant < ActiveRecord::Base
  def active_membership_end_date
    Date.today.advance(weeks: 8)
  end

  def display_name
    "display name"
  end

  def latest_action_at
    DateTime.new
  end
end
