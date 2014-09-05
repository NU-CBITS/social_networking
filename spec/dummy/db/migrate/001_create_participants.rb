# Dummy table only for use with tests.
class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.string :email
    end
  end
end
