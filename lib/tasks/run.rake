namespace :hermes_link do
  desc "Run 3CX plugin"
  task run: :environment do
    sh "cd ../.. && rails s"
  end
end
