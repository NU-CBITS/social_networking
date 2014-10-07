class AddUniquenessConstraintToLikes < ActiveRecord::Migration
  def change
    add_index :social_networking_likes, 
              [:participant_id, :item_id, :item_type],
              unique: true,
              name: "one_like_per_item"
  end
end
