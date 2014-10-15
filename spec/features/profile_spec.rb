require "spec_helper"

describe "profile", type: :feature, js: true do
  fixtures :all

  before { visit "/social_networking/profile_page" }

  scenario "Participant selects a profile icon" do
    click_on "profile-icon-selector"
    src = select_random_icon

    expect(page).to have_xpath("//img[@id='profile-icon' and @src='#{ src }']")
  end

  scenario "Participant answers a profile question" do
    question = social_networking_profile_questions(:profile_question1)
    find("#question-#{ question.id } button.edit").click
    fill_in question.question_text, with: "golf, hand grenades"
    click_on "Save"

    expect(page).to have_content("golf, hand grenades")
  end

  def select_random_icon
    icons = page.all(".icon-selection")
    icon = icons.at(rand(icons.length))
    icon_src = icon.find("img")[:src]
    icon.click

    icon_src
  end
end
