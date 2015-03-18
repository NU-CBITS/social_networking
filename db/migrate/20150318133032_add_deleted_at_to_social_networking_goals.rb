class AddDeletedAtToSocialNetworkingGoals < ActiveRecord::Migration
  def change
    add_column :social_networking_goals, :deleted_at, :datetime
  end
end
