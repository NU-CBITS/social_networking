require "spec_helper"

describe "goal tool", type: :feature, js: true do
  fixtures :all

  before { visit "/social_networking/goal_tool" }

  scenario "Participant enters a new goal" do
    click_button "+ add a goal"
    fill_in "What is your goal?", with: "all of the things"
    choose "end of 2 weeks"
    click_button "Save"

    expect(page).to have_content("all of the things")
  end

  scenario "Displays due date" do
    expect(page).to have_content "Due: #{Date.today.strftime('%Y-%m-%e')}"
  end

  scenario "Participant completes a goal" do
    complete "p1 alpha"

    expect(page).to have_completed_goal("p1 alpha")

    click_link "Completed"

    expect(page).to have_completed_goal("p1 alpha")
  end

  scenario "Participant removes a goal's completed status" do
    expect(page).to have_completed_goal("p1 epsilon")

    uncomplete "p1 epsilon"

    expect(page).not_to have_completed_goal("p1 epsilon")

    click_link "Completed"

    expect(page).not_to have_content("p1 epsilon")
  end

  scenario "Participant deletes a goal" do
    delete "p1 gamma"

    expect(page).not_to have_goal("p1 gamma")

    click_link "Deleted"

    expect(page).to have_goal("p1 gamma")
  end

  scenario "Participant restores a goal" do
    expect(page).not_to have_goal("p1 delta")

    click_link "Deleted"
    restore "p1 delta"

    expect(page).not_to have_goal("p1 delta")

    click_link "All"

    expect(page).to have_goal("p1 delta")
  end

  scenario "Participant edits a goal" do
    edit "p1 beta"
    fill_in "What is your goal?", with: "p1 beta foo"
    choose "end of 4 weeks"
    click_button "Save"

    expect(page).to have_content("p1 beta foo")
  end

  def have_goal(label)
    have_css("li.list-group-item p", text: label)
  end

  def have_completed_goal(label)
    have_css("li.list-group-item-success p", text: label)
  end

  def complete(label)
    goal = SocialNetworking::Goal.find_by_description(label)
    find("li#goal-#{ goal.id } button.complete").click
  end

  def uncomplete(label)
    goal = SocialNetworking::Goal.find_by_description(label)
    find("li#goal-#{ goal.id } button.complete").click
  end

  def delete(label)
    goal = SocialNetworking::Goal.find_by_description(label)
    find("li#goal-#{ goal.id } button.delete").click
  end

  def edit(label)
    goal = SocialNetworking::Goal.find_by_description(label)
    find("li#goal-#{ goal.id } button.edit").click
  end

  def restore(label)
    goal = SocialNetworking::Goal.find_by_description(label)
    find("li#goal-#{ goal.id } button.restore").click
  end
end
