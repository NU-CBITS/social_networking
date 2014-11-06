class SeedActiveFieldOfProfiles < ActiveRecord::Migration
  def change
    Profile.all.each do |profile|
      profile.update(active: true)
    end
  end
end


