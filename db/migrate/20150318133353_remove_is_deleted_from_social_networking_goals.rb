class RemoveIsDeletedFromSocialNetworkingGoals < ActiveRecord::Migration
  def change
    remove_column :social_networking_goals, :is_deleted
  end
end
