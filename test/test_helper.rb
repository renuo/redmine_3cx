# Load the Redmine helper
require "simplecov"
SimpleCov.root File.expand_path(File.dirname(__FILE__) + "/../")
SimpleCov.minimum_coverage 100
SimpleCov.start do
  add_filter "/test/system/settings_test.rb" if ENV["CI"] # Remove once capybara is setup for CI
  add_filter "/lib/tasks/run.rake"
  add_filter "/lib/tasks/test.rake"
end
require "rails-controller-testing"
Rails::Controller::Testing.install
require File.expand_path(File.dirname(__FILE__) + "/../../../test/test_helper")
require File.expand_path(File.dirname(__FILE__) + "/factories")
require File.expand_path(File.dirname(__FILE__) + "/support/benchmarker")
