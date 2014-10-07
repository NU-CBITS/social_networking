class AddItemLabelToSharedItems < ActiveRecord::Migration
  def change
    add_column :social_networking_shared_items, :item_label, :string
  end
end
