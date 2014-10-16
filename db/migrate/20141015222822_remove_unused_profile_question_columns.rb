class RemoveUnusedProfileQuestionColumns < ActiveRecord::Migration
  def change
    remove_column :social_networking_profile_questions, :order, :integer
    remove_column :social_networking_profile_questions, :allowed_responses, :integer, default: 1, null: false
    remove_column :social_networking_profile_questions, :deleted, :boolean, null: false
  end
end
