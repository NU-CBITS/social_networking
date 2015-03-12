class AddStudyidToParticipant < ActiveRecord::Migration
  def change
      add_column :participants, :study_id, :string
  end
end