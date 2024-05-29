namespace :redmine_3cx do
  desc "Run 3CX plugin"
  task run: :environment do
    sh "rails s"
  end
end
