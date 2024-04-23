namespace :hermes_link do
  desc "Run 3CX plugin checks"
  task check: :environment do
    sh "rake redmine:plugins:test NAME=hermes_link"
  end
end
