class AddParticipantIdToSocialNetworkingSharedItems < ActiveRecord::Migration
  def change
    add_column :social_networking_shared_items, :participant_id, :integer
    add_index :social_networking_shared_items, :participant_id
  end
end
