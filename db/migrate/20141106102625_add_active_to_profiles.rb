class AddActiveToProfiles < ActiveRecord::Migration
  def change
    add_column :social_networking_profiles, :active, :boolean
  end
end
