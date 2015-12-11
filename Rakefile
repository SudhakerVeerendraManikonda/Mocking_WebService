require 'rake'
require 'rake/testtask'

Rake::TestTask.new('test') do |test|
  test.pattern = 'test/*_test.rb'
  test.verbose = true
  test.warning = true
end

task :run do
  ruby "src/net_asset_value_driver.rb"
end

task :default => [:test , :run]
