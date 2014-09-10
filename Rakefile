begin
  require "bundler/setup"
rescue LoadError
  puts "You must `gem install bundler` and `bundle install` to run rake tasks"
end

APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)

load "rails/tasks/engine.rake"

Bundler::GemHelper.install_tasks

Dir[File.join(File.dirname(__FILE__), "tasks/**/*.rake")].each { |f| load f }

require "rspec/core"
require "rspec/core/rake_task"

desc "Run all Ruby specs"
RSpec::Core::RakeTask.new(spec: "app:db:test:prepare")

desc "Run all JS specs"
task :js_spec do
  Rake::Task["app:spec:javascript"].invoke
end

desc "Run all specs"
task :all_spec do
  Rake::Task["spec"].invoke
  Rake::Task["js_spec"].invoke
end

require "jshintrb/jshinttask"
Jshintrb::JshintTask.new :jshint do |t|
  t.pattern = "app/assets/javascripts/**/*.js"
  t.options = :defaults
  t.globals = [:angular, :moment, "$"]
end

require "rubocop/rake_task"
RuboCop::RakeTask.new

desc "Run all linters"
task :lint do
  Rake::Task["jshint"].invoke
  Rake::Task["rubocop"].invoke
end

desc "Run all specs and linters"
task :spec_lint do
  Rake::Task["all_spec"].invoke
  Rake::Task["lint"].invoke
end

task default: :spec_lint
