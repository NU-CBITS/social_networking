class CreateSocialNetworkingOnTheMindStatements < ActiveRecord::Migration
  def change
    create_table :social_networking_on_the_mind_statements do |t|
      t.text :description, null: false
      t.integer :participant_id, null: false

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        execute <<-SQL
          ALTER TABLE social_networking_on_the_mind_statements
            ADD CONSTRAINT fk_on_the_mind_participants
            FOREIGN KEY (participant_id)
            REFERENCES participants(id)
        SQL
      end

      dir.down do
        execute <<-SQL
          ALTER TABLE social_networking_on_the_mind_statements
            DROP CONSTRAINT IF EXISTS fk_on_the_mind_participants
        SQL
      end
    end
  end
end
