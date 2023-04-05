require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:test) do |t|
  t.pattern = "spec/*.rb"
end

desc "Run application"
task :run do
  sh "bin/vending_machine"
end

desc "Run tests"
task :test
