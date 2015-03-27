class AddIndexToLikeItemIdAndItemTypes < ActiveRecord::Migration
  def change
    add_index :social_networking_likes, [:item_id, :item_type]
  end
end
