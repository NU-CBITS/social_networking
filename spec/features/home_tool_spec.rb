require "spec_helper"

describe "home tool", type: :feature, js: true do
  fixtures(:all)

  before { visit "/social_networking/home" }

  scenario "Participant views feed" do
    statement =
      social_networking_on_the_mind_statements(:participant2_statement1)
    expect(page).to have_content(statement.description)
  end

  scenario "Participant enters a new \"What's on your mind?\"" do
    click_on "What's on your mind?"
    fill_in "What's on your mind?", with: "It's raining"
    click_button "Save"

    expect(page).to have_content("It's raining")
  end
end
