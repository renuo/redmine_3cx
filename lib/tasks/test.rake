namespace :redmine_3cx do
  desc "Run 3CX plugin checks"
  task check: :environment do
    sh "rake redmine:plugins:test NAME=redmine_3cx"
  end
end
