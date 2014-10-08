class AddIconNameToProfiles < ActiveRecord::Migration
  def change
    add_column :social_networking_profiles, :icon_name, :string
  end
end
