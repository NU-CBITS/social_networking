require "spec_helper"

describe "group goals", type: :feature, js: true do
  fixtures(:all)

  before { visit "/social_networking/group_goals" }

  scenario "Participant views others' goals" do
    expect(page).not_to have_content("p1 alpha")
    expect(page).to have_content("p2 alpha")
    expect(page).not_to have_content("p2 delta")
  end
end
