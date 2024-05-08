namespace :redmine_3cx_plugin do
  desc "Run 3CX plugin checks"
  task check: :environment do
    sh "RAILS_ENV=test bundle exec rake test TEST=plugins/redmine_3cx_plugin/test/functional/polls_controller_test.rb"
  end
end
