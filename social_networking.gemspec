$LOAD_PATH.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "social_networking/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "social_networking"
  s.version     = SocialNetworking::VERSION
  s.authors     = ["Eric Carty-Fickes"]
  s.email       = ["ericcf@northwestern.edu"]
  s.homepage    = "https://github.com/cbitstech/social_networking"
  s.summary     = "Social networking components"
  s.description = "Social networking components"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*",
                "MIT-LICENSE",
                "Rakefile",
                "README.md"]

  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.1"

  s.add_dependency "twilio-ruby", "~> 3.12"
  
  s.add_dependency "sprockets-rails", "= 2.2.2"

  s.add_development_dependency "pg"
  s.add_development_dependency "rspec-rails", "~> 3"
  s.add_development_dependency "capybara", "~> 2"
  s.add_development_dependency "poltergeist"
  s.add_development_dependency "jshintrb", "~> 0.2"
  # needed in CI environment
  s.add_development_dependency "therubyracer"
  s.add_development_dependency "simplecov", "~> 0.9.1"
end
