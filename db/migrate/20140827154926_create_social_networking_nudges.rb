class CreateSocialNetworkingNudges < ActiveRecord::Migration
  def change
    create_table :social_networking_nudges do |t|
      t.integer :initiator_id, null: false
      t.integer :recipient_id, null: false

      t.timestamps
    end
  end
end
