class CreateSocialNetworkingComments < ActiveRecord::Migration
  def change
    create_table :social_networking_comments do |t|
      t.integer :participant_id, null: false
      t.string :text, null: false
      t.integer :item_id, null: false
      t.string :item_type, null: false

      t.timestamps
    end
  end
end
