class CreateSocialNetworkingGoals < ActiveRecord::Migration
  def change
    create_table :social_networking_goals do |t|
      t.string :description, null: false
      t.integer :participant_id, null: false
      t.boolean :is_completed, null: false, default: false
      t.boolean :is_deleted, null: false, default: false

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        execute <<-SQL
          ALTER TABLE social_networking_goals
            ADD CONSTRAINT fk_goals_participants
            FOREIGN KEY (participant_id)
            REFERENCES participants(id)
        SQL
      end

      dir.down do
        execute <<-SQL
          ALTER TABLE social_networking_goals
            DROP CONSTRAINT IF EXISTS fk_goals_participants
        SQL
      end
    end
  end
end
