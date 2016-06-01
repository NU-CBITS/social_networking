# frozen_string_literal: true
require "spec_helper"

describe "goal tool", type: :feature, js: true do
  fixtures :all

  before { visit "/social_networking/goal_tool" }

  describe "Participant enters a new goal" do
    let(:two_weeks) { Time.current.advance(days: 14).strftime("%b %d %Y") }
    let(:eight_weeks) { Time.current.advance(days: 56).strftime("%b %d %Y") }

    scenario "goal is to be completed within 2 weeks" do
      click_button "+ add a goal"
      fill_in "What is your goal?", with: "all of the things"
      choose "end of 2 weeks"
      click_button "Save"

      expect(page)
        .to have_content "all of the things Due: #{two_weeks}"
    end

    scenario "goal is to be completed at the end of the study" do
      click_button "+ add a goal"
      fill_in "What is your goal?", with: "the end!"
      choose "end of study"
      click_button "Save"

      expect(page)
        .to have_content "the end! Due: #{eight_weeks}"
    end

    scenario "goal is to be completed within no specific date" do
      click_button "+ add a goal"
      fill_in "What is your goal?", with: "When should I finish this?"
      choose "no specific date"
      click_button "Save"

      expect(page)
        .to have_content "When should I finish this? Due: no date given"
    end
  end

  scenario "Displays due date" do
    expect(page).to have_content "Due: #{Time.zone.today.strftime("%b %d %Y")}"
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
    find("li#goal-#{goal.id} button.complete").click
  end

  def uncomplete(label)
    goal = SocialNetworking::Goal.find_by_description(label)
    find("li#goal-#{goal.id} button.complete").click
  end

  def delete(label)
    goal = SocialNetworking::Goal.find_by_description(label)
    find("li#goal-#{goal.id} button.delete").click
  end

  def edit(label)
    goal = SocialNetworking::Goal.find_by_description(label)
    find("li#goal-#{goal.id} button.edit").click
  end

  def restore(label)
    goal = SocialNetworking::Goal.find_by_description(label)
    find("li#goal-#{goal.id} button.restore").click
  end
end
