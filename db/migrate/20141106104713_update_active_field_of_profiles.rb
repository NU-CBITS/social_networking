class UpdateActiveFieldOfProfiles < ActiveRecord::Migration
  def change
    Profile.each do |profile|
      profile.update(active: true)
    end
  end
end
