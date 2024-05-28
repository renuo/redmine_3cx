# Load the Redmine helper
require "simplecov"
SimpleCov.root File.expand_path(File.dirname(__FILE__) + "/../")
SimpleCov.minimum_coverage 100
SimpleCov.start
require "rails-controller-testing"
Rails::Controller::Testing.install
require File.expand_path(File.dirname(__FILE__) + "/../../../test/test_helper")
require File.expand_path(File.dirname(__FILE__) + "/factories")
require File.expand_path(File.dirname(__FILE__) + "/support/benchmarker")
