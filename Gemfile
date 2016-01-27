source "https://rubygems.org"

# Declare your gem"s dependencies in social_networking.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem "debugger"
gem "jquery-rails", "~> 3.1"
gem "bootstrap-sass", "~> 3.1"
gem "twilio-ruby", "~> 3.12"

gem "git_tagger",
    tag: "1.1.8",
    git: "https://github.com/cbitstech/git_tagger.git"

group :development, :test do
  gem "jasmine-rails", "= 0.10.0"
  gem "rubocop", "~> 0.25"
end

group :development do
  gem "brakeman", require: false
end
