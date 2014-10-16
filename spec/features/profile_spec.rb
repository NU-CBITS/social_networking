require "spec_helper"

describe "Profile", type: :feature, js: true do
  fixtures :all

  before do
    # generate profile
    visit "/social_networking/profile_page"
  end

  scenario "Participant selects a profile icon" do
    click_on "profile-icon-selector"
    src = select_random_icon

    expect(page).to have_xpath("//img[@id='profile-icon'][@src='#{ src }']")
  end

  scenario "Participant answers a profile question" do
    question = social_networking_profile_questions(:profile_question1)
    fill_in question.question_text, with: "golf, hand grenades"
    within "#question-#{ question.id }" do
      click_on "Save"
    end

    expect(page).to have_content("golf, hand grenades")
  end

  describe "other" do
    let(:profile2) { social_networking_profiles(:profile2) }

    before { visit "/social_networking/profile_page/#{ profile2.id }" }

    scenario "Participant nudges Participant" do
      click_on "Nudge"

      expect(page).to have_content("Nudge sent!")

      visit "/social_networking/home"

      expect(page).to have_content("nudged #{ profile2.user_name }")
    end
  end

  def select_random_icon
    icons = page.all(".icon-selection")
    icon = icons.at(rand(icons.length))
    icon_src = icon.find("img")[:src]
    icon.click

    icon_src
  end
end
