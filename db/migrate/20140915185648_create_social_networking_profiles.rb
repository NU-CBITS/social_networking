class CreateSocialNetworkingProfiles < ActiveRecord::Migration
  def change

    create_table :social_networking_profiles do |t|
      t.integer :participant_id, null: false
      t.boolean :active, null: false

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        execute <<-SQL
          ALTER TABLE social_networking_profiles
            ADD CONSTRAINT fk_profiles_participants
            FOREIGN KEY (participant_id)
            REFERENCES participants(id)
        SQL
      end

      dir.down do
        execute <<-SQL
          ALTER TABLE social_networking_profiles
            DROP CONSTRAINT IF EXISTS fk_profiles_participants
        SQL
      end
    end

  end
end
