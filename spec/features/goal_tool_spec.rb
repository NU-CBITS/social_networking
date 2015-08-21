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
    expect(page).to have_content "Due: #{Date.today.to_s(:date)}"
  end

  scenario "Participant completes a goal" do
    complete "p1 alpha"

    expect(page).to have_completed_goal("p1 alpha")

    click_link "Completed"

    expect(page).to have_completed_goal("p1 alpha")
  end

  scenario "Participant deletes a goal" do
    delete "p1 gamma"

    expect(page).not_to have_goal("p1 gamma")

    click_link "Deleted"

    expect(page).to have_goal("p1 gamma")
  end

  scenario "Participant edits a goal" do
    edit "run"
    fill_in "What is your goal?", with: "run foo"
    choose "end of 4 weeks"
    click_button "Save"

    expect(page).to have_content("run foo")
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
