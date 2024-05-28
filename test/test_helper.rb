# Load the Redmine helper
require "simplecov"
SimpleCov.start do
  add_filter %r{^/plugins/redmine_3cx/}
end
SimpleCov.minimum_coverage 100
require "rails-controller-testing"
Rails::Controller::Testing.install
require File.expand_path(File.dirname(__FILE__) + "/../../../test/test_helper")
require File.expand_path(File.dirname(__FILE__) + "/factories")
require File.expand_path(File.dirname(__FILE__) + "/support/benchmarker")
