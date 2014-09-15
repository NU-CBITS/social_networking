class CreateSocialNetworkingProfileQuestions < ActiveRecord::Migration
  def change

    create_table :social_networking_profile_questions do |t|
      t.integer :order, null: true
      t.integer :allowed_responses, null:false, default: 1
      t.string :question_text, null: false
      t.boolean :deleted, null: false

      t.timestamps
    end

  end
end
