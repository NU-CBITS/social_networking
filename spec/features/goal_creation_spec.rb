require "spec_helper"

describe "goal creation", type: :feature, js: true do
  fixtures(:participants)

  scenario "Participant enters new goals" do
    visit "/social_networking/create_goal"
    fill_in "What is your goal?", with: "all of the things"
    click_button "Save"

    expect(page).to have_content("all of the things")
  end
end
