namespace :hermes_link do
  desc "Run 3CX plugin checks"
  task check: :environment do
    sh "RAILS_ENV=test bundle exec rake test TEST=plugins/hermes_link/test/functional/polls_controller_test.rb"
  end
end
