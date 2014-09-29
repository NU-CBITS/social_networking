class AddUniqueConstraintToProfileAnswers < ActiveRecord::Migration
  def change
    add_index(:social_networking_profile_answers,
              [:social_networking_profile_id, :social_networking_profile_question_id],
              unique: true,
              name: 'profile_answers_unique')
  end
end
