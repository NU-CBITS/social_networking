class AddActionTypeToSharedItems < ActiveRecord::Migration
  def change
    add_column :social_networking_shared_items, :action_type, :string, null: false, default: ""
  end
end
