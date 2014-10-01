class DropParticipantIdFromSharedItems < ActiveRecord::Migration
  def change
    remove_column :social_networking_shared_items, :participant_id, :integer, null: true
    add_column :social_networking_shared_items, :is_public, :boolean, null: false, default: true
  end
end
