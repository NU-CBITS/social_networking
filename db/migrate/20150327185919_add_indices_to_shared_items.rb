class AddIndicesToSharedItems < ActiveRecord::Migration
  def change
    add_index :social_networking_shared_items, :created_at
  end
end
