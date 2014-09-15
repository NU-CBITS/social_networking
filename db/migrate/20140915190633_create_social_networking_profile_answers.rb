class CreateSocialNetworkingProfileAnswers < ActiveRecord::Migration
  def change

    create_table :social_networking_profile_answers do |t|
      t.integer :profile_question_id, null: false
      t.integer :order, null: true
      t.string :answer_text, null: false

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        execute <<-SQL
          ALTER TABLE social_networking_profile_answers
            ADD CONSTRAINT fk_profile_answers_profile_questions
            FOREIGN KEY (profile_question_id)
            REFERENCES social_networking_profile_questions(id)
        SQL
      end

      dir.down do
        execute <<-SQL
          ALTER TABLE social_networking_profile_answers
            DROP CONSTRAINT IF EXISTS fk_profile_answers_profile_questions
        SQL
      end
    end

  end
end
