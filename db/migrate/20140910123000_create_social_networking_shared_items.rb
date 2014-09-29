class CreateSocialNetworkingSharedItems < ActiveRecord::Migration
  def change
    create_table :social_networking_shared_items do |t|
      t.integer :participant_id, null: false
      t.integer :item_id, null: false
      t.string :item_type, null: false

      t.timestamps
    end
  end
end
