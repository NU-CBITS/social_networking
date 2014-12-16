class CreateArms < ActiveRecord::Migration
  def change
    create_table :arms do |t|
      t.string :title, default: ""
      t.boolean :is_social, default: false
    end
  end
end
