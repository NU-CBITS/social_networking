class PopulateProfilesForExistingParticipants < ActiveRecord::Migration
  def change
    Participant.all.each do |participant|
      if !Profile.where(participant_id: participant.id)
        Profile.create(participant_id: participant.id, active: true)
      end
    end
  end
end
