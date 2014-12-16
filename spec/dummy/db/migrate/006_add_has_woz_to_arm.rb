class AddHasWozToArm < ActiveRecord::Migration
  def change
    add_column :arms, :has_woz, :boolean, default: false
  end
end
