class Participant < ActiveRecord::Base
  def active_membership_end_date
    Date.today.advance(weeks: 8)
  end

  def latest_action_at
    DateTime.new
  end

  def contact_preference
    "email"
  end

  def phone_number
    '16309101110'
  end
end
