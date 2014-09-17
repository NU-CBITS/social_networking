class AddProfileToSocialNetworkingProfileAnswers < ActiveRecord::Migration
  def change
    add_reference :social_networking_profile_answers, :social_networking_profile, index: false

    reversible do |dir|
      dir.up do
        execute <<-SQL
          ALTER TABLE social_networking_profile_answers
            ADD CONSTRAINT fk_profile_answers_profiles
            FOREIGN KEY (social_networking_profile_id)
            REFERENCES social_networking_profiles(id)
        SQL
      end

      dir.down do
        execute <<-SQL
          ALTER TABLE social_networking_profile_answers
            DROP CONSTRAINT IF EXISTS fk_profile_answers_profiles
        SQL
      end
    end
  end
end
