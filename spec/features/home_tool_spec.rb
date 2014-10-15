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

  scenario "Participant likes an existing \"What's on your mind?\"" do
    expect(page).not_to have_likes_for(statement)

    like statement

    expect(page).to have_likes_for(statement)
  end

  scenario "Participant likes a Goal" do
    goal = social_networking_shared_items(:participant1_goal_alpha)

    expect(page).not_to have_likes_for(goal)

    like goal

    expect(page).to have_likes_for(goal)
  end

  def comment_on(item)
    find(:xpath, "//*[@id='#{ item_el_id(item) }']")
      .find("button.comment").click
  end

  def expand_comments_on(item)
    find(:xpath, "//*[@id='#{ item_el_id(item) }']")
      .find("button.comments").click
  end

  def like(item)
    find(:xpath, "//*[@id='#{ item_el_id(item) }']")
      .find("button.like").click
  end

  def have_likes_for(item)
    have_selector(
      :xpath,
      "//*[@id='#{ item_el_id(item) }']/" \
      "*[@class='actions']/button[@class='btn btn-link likes']"
    )
  end

  def item_el_id(item)
    "#{ item.class }-#{ item.id }"
  end
end
