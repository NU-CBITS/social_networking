class Participant < ActiveRecord::Base
  def active_membership_end_date
    Date.today.advance(weeks: 8)
  end
end
