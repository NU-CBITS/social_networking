require "spec_helper"

describe "goal tool", type: :feature, js: true do
  fixtures(:all)

  before { visit "/social_networking/goal_tool" }

  scenario "Participant enters a new goal" do
    click_button "+ add a goal"
    fill_in "What is your goal?", with: "all of the things"
    click_button "Save"

    expect(page).to have_content("all of the things")
  end

  scenario "Participant completes a goal" do
    check "alpha"

    expect(page).to have_completed_goal("alpha")

    click_link "Completed"

    expect(page).to have_completed_goal("alpha")
  end

  scenario "Participant removes a goal's completed status" do
    expect(page).to have_completed_goal("beta")

    uncheck "beta"

    expect(page).not_to have_completed_goal("beta")

    click_link "Completed"

    expect(page).not_to have_content("beta")
  end

  scenario "Participant deletes a goal" do
    delete "gamma"

    expect(page).not_to have_goal("gamma")

    click_link "Deleted"

    expect(page).to have_goal("gamma")
  end

  scenario "Participant restores a goal" do
    expect(page).not_to have_goal("delta")

    click_link "Deleted"
    restore "delta"

    expect(page).not_to have_goal("delta")

    click_link "All"

    expect(page).to have_goal("delta")
  end

  def have_goal(label)
    have_css("li.list-group-item label", text: label)
  end

  def have_completed_goal(label)
    have_css("li.list-group-item-success label", text: label)
  end

  def delete(label)
    goal = SocialNetworking::Goal.find_by_description(label)
    find("li#goal-#{ goal.id } button.delete").click
  end

  def restore(label)
    goal = SocialNetworking::Goal.find_by_description(label)
    find("li#goal-#{ goal.id } button.restore").click
  end
end
