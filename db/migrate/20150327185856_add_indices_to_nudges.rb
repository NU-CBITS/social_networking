class AddIndicesToNudges < ActiveRecord::Migration
  def change
    add_index :social_networking_nudges, :initiator_id
    add_index :social_networking_nudges, :recipient_id
    add_index :social_networking_nudges, :created_at
  end
end
