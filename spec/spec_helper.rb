ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rspec/rails"
require "capybara/rspec"
require "capybara/poltergeist"

require "simplecov"
SimpleCov.minimum_coverage 83
SimpleCov.start "rails"

Capybara.javascript_driver = :poltergeist

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{ File.dirname(__FILE__) }/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.fixture_path = "#{ File.dirname(__FILE__) }/fixtures"
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
  config.include Rails.application.routes.url_helpers

  # Include our own helpers
  config.include Controllers::JsonHelpers, type: :controller
end
