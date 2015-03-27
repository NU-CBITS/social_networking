class AddIndicesToOnTheMindStatements < ActiveRecord::Migration
  def change
    add_index :social_networking_on_the_mind_statements, :participant_id, name: "on_the_mind_participant"
    add_index :social_networking_on_the_mind_statements, :created_at, name: "on_the_mind_created_at"
  end
end
