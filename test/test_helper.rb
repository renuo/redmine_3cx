# Load the Redmine helper
require "simplecov"
SimpleCov.start do
  enable_coverage :branch
  add_filter "/test/"
  add_filter do |source_file|
    source_file.filename !~ %r{/plugins/redmine_3cx/}
  end
end
SimpleCov.minimum_coverage line: 100, branch: 100
require File.expand_path(File.dirname(__FILE__) + "/../../../test/test_helper")
