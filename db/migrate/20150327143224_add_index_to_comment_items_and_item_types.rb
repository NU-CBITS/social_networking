class AddIndexToCommentItemsAndItemTypes < ActiveRecord::Migration
  def change
    add_index :social_networking_comments, [:item_id, :item_type]
  end
end
