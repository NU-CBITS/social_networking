# frozen_string_literal: true
require "active_record/fixtures"

namespace :seed do
  desc "seed the database with fixtures from spec/fixtures"
  task with_social_networking_fixtures: :environment do
    if Rails.env.production?
      puts "ERROR: You should not seed production database with fixtures."
    else
      path = File.join(File.dirname(__FILE__), "..", "..", "spec", "fixtures")
      ActiveRecord::FixtureSet.create_fixtures path, [
        "social_networking/goals", :"social_networking/profiles",
        :"social_networking/profile_questions",
        :"social_networking/profile_answers"
      ]
    end
  end
end
