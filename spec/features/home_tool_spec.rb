# frozen_string_literal: true
require "spec_helper"

describe "home tool", type: :feature, js: true do
  fixtures :all

  let(:statement) do
    social_networking_on_the_mind_statements(:participant2_statement1)
  end
  let(:participant1) { participants(:participant1) }
  let(:participant2) { participants(:participant2) }

  before do
    # generate profile
    visit "/social_networking/profile_page"
    visit "/social_networking/home"
  end

  def comment_on(item)
    find(:xpath, "//*[@id='#{item_el_id(item)}']")
      .find("button.comment").click
  end

  def expand_comments_on(item)
    find(:xpath, "//*[@id='#{item_el_id(item)}']")
      .find("button.comments").click
  end

  def like(item)
    find(:xpath, "//*[@id='#{item_el_id(item)}']")
      .find("button.like").click
  end

  def have_likes_for(item)
    have_selector(
      :xpath,
      "//*[@id='#{item_el_id(item)}']/" \
      "*[@class='actions']/button[@class='btn btn-link likes']"
    )
  end

  def item_el_id(item)
    "#{item.class}-#{item.id}"
  end
end
