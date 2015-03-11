class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :participant_id, null: false
      t.timestamps null: false
    end
  end
end
