class PopulateDeletedAtInSocialNetworkingGoals < ActiveRecord::Migration
  def change
    SocialNetworking::Goal.all.each do |goal|
      goal.update(created_at: goal.deleted_at) if goal.is_deleted
    end
  end
end
