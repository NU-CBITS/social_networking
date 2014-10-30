# Update to dummy table only for use with tests.
class AddParticipantFields < ActiveRecord::Migration
  def change
    add_column :participants, :phone_number, :string
    add_column :participants, :contact_preference, :string
  end
end
