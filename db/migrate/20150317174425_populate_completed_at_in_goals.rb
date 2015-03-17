class PopulateCompletedAtInGoals < ActiveRecord::Migration
  def change
    SocialNetworking::Goal.all.each do |goal|
      goal.update(created_at: goal.updated_at) if goal.is_completed
    end
  end
end
