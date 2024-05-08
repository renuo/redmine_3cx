namespace :redmine_3cx_plugin do
  desc "Run 3CX plugin"
  task run: :environment do
    sh "cd ../.. && rails s"
  end
end
