class AddCompletedAtToGoals < ActiveRecord::Migration
  def change
    add_column :social_networking_goals, :completed_at, :datetime
  end
end
