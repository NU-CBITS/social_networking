# frozen_string_literal: true
$LOAD_PATH.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "social_networking/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "social_networking"
  s.version     = SocialNetworking::VERSION
  s.authors     = ["Eric Carty-Fickes", "Eric Schlange", "Michael Wehrley"]
  s.email       = ["eric.schlange@northwestern.edu"]
  s.homepage    = "https://github.com/NU-CBITS/social_networking"
  s.summary     = "Social networking components"
  s.description = "Social networking components, including the feed tool"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib,vendor}/**/*",
                "MIT-LICENSE",
                "Rakefile",
                "README.md"]

  s.test_files = Dir["spec/**/*"]

  s.add_dependency "jquery-rails", "~> 3.1"
  s.add_dependency "twilio-ruby", "~> 3.12"
  s.add_dependency "sprockets-rails", "= 2.2.2"
  s.add_dependency "bootstrap-sass", "~> 3.1"
  s.add_dependency "rubocop", "~> 0.25"

  s.add_development_dependency "git_tagger", "~> 1.1"
  s.add_development_dependency "pg", "~> 0.18"
  s.add_development_dependency "phantomjs", "~> 1.9"
  s.add_development_dependency "rspec-rails", "~> 3.5.0.beta3"
  s.add_development_dependency "capybara", "~> 2"
  s.add_development_dependency "poltergeist", "~> 1.8"
  s.add_development_dependency "jshintrb", "~> 0.2"
  # needed in CI environment
  s.add_development_dependency "therubyracer", "~> 0.12"
  s.add_development_dependency "brakeman", "~> 3"
  s.add_development_dependency "simplecov", "~> 0.9.1"
end
