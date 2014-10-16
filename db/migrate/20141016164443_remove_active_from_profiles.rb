class RemoveActiveFromProfiles < ActiveRecord::Migration
  def change
    remove_column :social_networking_profiles, :active, :boolean, null: false
  end
end
