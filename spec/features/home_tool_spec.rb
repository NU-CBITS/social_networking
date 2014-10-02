require "spec_helper"

describe "home tool", type: :feature, js: true do
  fixtures :all

  let(:statement) do
    social_networking_on_the_mind_statements(:participant2_statement1)
  end
  let(:participant1) { participants(:participant1) }
  let(:participant2) { participants(:participant2) }

  before { visit "/social_networking/home" }

  scenario "Participant views feed" do
    expect(page).to have_content(statement.description)
    expect(page).to have_content(
      "#{ participant1.id } nudged #{ participant2.id }"
    )
  end

  scenario "Participant enters a new \"What's on your mind?\"" do
    click_on "What's on your mind?"
    fill_in "What's on your mind?", with: "It's raining"
    click_button "Save"

    expect(page).to have_content("It's raining")
  end

  scenario "Participant comments on an existing \"What's on your mind?\"" do
    comment_on statement
    fill_in "What do you think?", with: "brilliant!"
    click_button "Save"
    expand_comments_on statement

    expect(page).to have_content("brilliant!")
  end

  def comment_on(item)
    find(:xpath, "//*[@id='#{ item.class }-#{ item.id }']")
      .find("button.comment").click
  end

  def expand_comments_on(item)
    find(:xpath, "//*[@id='#{ item.class }-#{ item.id }']")
      .find("button.comments").click
  end
end
