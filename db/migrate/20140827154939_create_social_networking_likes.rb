class CreateSocialNetworkingLikes < ActiveRecord::Migration
  def change
    create_table :social_networking_likes do |t|
      t.integer :participant_id, null: false
      t.integer :item_id, null: false
      t.string :item_type, null: false

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        execute <<-SQL
          ALTER TABLE social_networking_likes
            ADD CONSTRAINT fk_likes_participants
            FOREIGN KEY (participant_id)
            REFERENCES participants(id)
        SQL
      end

      dir.down do
        execute <<-SQL
          ALTER TABLE social_networking_likes
            DROP CONSTRAINT IF EXISTS fk_likes_participants
        SQL
      end
    end
  end
end
