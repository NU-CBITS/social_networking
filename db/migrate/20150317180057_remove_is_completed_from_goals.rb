class RemoveIsCompletedFromGoals < ActiveRecord::Migration
  def change
    remove_column :social_networking_goals, :is_completed
  end
end
