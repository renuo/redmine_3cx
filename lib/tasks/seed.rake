namespace :redmine_3cx do
  desc "Seed database (ALLOW_PRODUCTION=true to run on prod)"
  task seed: :environment do
    raise "Seed blocked on production. Use: ALLOW_PRODUCTION=true bundle exec rake redmine_3cx:seed" if Rails.env.production? && ENV["ALLOW_PRODUCTION"] != "true"

    require File.expand_path(File.dirname(__FILE__) + "/../../test/factories")
    require File.expand_path(File.dirname(__FILE__) + "/../../init.rb")

    User.where(login: "3cx_service_account").destroy_all
    Project.where(name: "Project").destroy_all

    role = Role.find_or_create_by!(name: "3cx_api") { |r| r.permissions = [:use_api] }
    puts "Created Role: #{role.name}"

    project = FactoryBot.create(:project)
    puts "Created Project: #{project.name}"

    account = FactoryBot.create(:user, login: "service_account")
    puts "Created User: #{account.login}"

    Member.create!(user_id: account.id, project_id: project.id, roles: [role])
    contacts = [
      FactoryBot.create(:contact, first_name: "John", project:, phone: "+41 78 123 45 67"),
      FactoryBot.create(:contact, first_name: "Zoe", project:, phone: "078 111 22 33"),
      FactoryBot.create(:contact, first_name: "Henry", project:, phone: "+41 78 111 22 33"),
    ]

    puts "Created Contacts:"
    contacts.each do |contact|
      puts "- #{contact.first_name} #{contact.last_name}, #{contact.phones}"
    end

    raise "Permission check failed" unless account.allowed_to?(:use_api, contacts.last.project)

    credentials = "#{account.api_key}:x"
    puts "API Key: #{account.api_key}"
    puts(<<~CURL
         curl --request GET \\
           --url 'http://localhost:3000/3cx/contacts.json?phone=#{URI.encode_uri_component(contacts.first.phones.first)}' \\
           --header 'authorization: Basic #{Base64.encode64(credentials).chomp}'
    CURL
    )
  end
end

