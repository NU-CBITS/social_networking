class AddNullFalseToArms < ActiveRecord::Migration
  def change
    change_column_null :arms, :title, false
    change_column_null :arms, :is_social, false
  end
end