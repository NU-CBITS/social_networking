class ChangeOnTheMindStatementsProfileAnswersCommentsTextLength < ActiveRecord::Migration
  def change
    change_column :social_networking_comments, :text, :string, limit: 1000
    change_column :social_networking_goals, :description, :string, limit: 1000
    change_column :social_networking_on_the_mind_statements, :description, :string, limit: 1000
    change_column :social_networking_profile_answers, :answer_text, :string, limit: 1000
  end
end
