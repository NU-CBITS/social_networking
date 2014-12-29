class AddParticipantIdToSocialNetworkingSharedItemsDataMigration < ActiveRecord::Migration
  def change
    SocialNetworking::SharedItem.where(participant_id: nil).each do |shared_item|
      shared_item.update(participant_id: shared_item.item.participant.id)
    end
  end
end
