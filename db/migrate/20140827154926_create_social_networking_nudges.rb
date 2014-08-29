class CreateSocialNetworkingNudges < ActiveRecord::Migration
  def change
    create_table :social_networking_nudges do |t|
      t.integer :initiator_id, null: false
      t.integer :recipient_id, null: false

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        execute <<-SQL
          ALTER TABLE social_networking_nudges
            ADD CONSTRAINT fk_nudges_initiators
            FOREIGN KEY (initiator_id)
            REFERENCES participants(id)
        SQL

        execute <<-SQL
          ALTER TABLE social_networking_nudges
            ADD CONSTRAINT fk_nudges_recipients
            FOREIGN KEY (recipient_id)
            REFERENCES participants(id)
        SQL
      end

      dir.down do
        execute <<-SQL
          ALTER TABLE social_networking_nudges
            DROP CONSTRAINT IF EXISTS fk_nudges_initiators
        SQL

        execute <<-SQL
          ALTER TABLE social_networking_nudges
            DROP CONSTRAINT IF EXISTS fk_nudges_recipients
        SQL
      end
    end
  end
end
