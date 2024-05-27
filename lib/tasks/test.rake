namespace :redmine_3cx do
  desc "Run 3CX plugin checks"
  task check: :environment do
    sh "RAILS_ENV=test bundle exec rake redmine:plugins:test NAME=redmine_3cx"
  end
end
