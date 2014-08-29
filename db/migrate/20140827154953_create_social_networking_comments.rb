class CreateSocialNetworkingComments < ActiveRecord::Migration
  def change
    create_table :social_networking_comments do |t|
      t.integer :participant_id, null: false
      t.string :text, null: false
      t.integer :item_id, null: false
      t.string :item_type, null: false

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        execute <<-SQL
          ALTER TABLE social_networking_comments
            ADD CONSTRAINT fk_comments_participants
            FOREIGN KEY (participant_id)
            REFERENCES participants(id)
        SQL
      end

      dir.down do
        execute <<-SQL
          ALTER TABLE social_networking_comments
            DROP CONSTRAINT IF EXISTS fk_comments_participants
        SQL
      end
    end
  end
end
