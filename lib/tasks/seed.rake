namespace :redmine_3cx do
  desc "Seed"
  task seed: :environment do
    require File.expand_path(File.dirname(__FILE__) + "/../../test/factories")
    require File.expand_path(File.dirname(__FILE__) + "/../../init.rb")
    User.where(login: "service_account").destroy_all
    Project.where(name: "Project").destroy_all
    role = create_role
    project = create_sample_project
    account = create_service_account
    create_membership(account, project, role)
    contacts = create_contacts(project)

    account.allowed_to?(:use_api, contacts.last.project)
    assert!(account.allowed_to?(:use_api, contacts.last.project), "Expected account to have sufficient permissions")

    puts("Feel free to test API with sample account once server is running:")

    credentials = "#{account.api_key}:x"
    puts(
      <<~ACC
        curl --request GET \\
          --url 'http://localhost:3000/3cx/contacts.json?phone=#{URI.encode_uri_component(contacts.first.phones.first)}' \\
          --header 'authorization: Basic #{Base64.strict_encode64(credentials)}'
      ACC
    )
  end

  def assert!(condition, message)
    raise message if !condition

    condition
  end

  def create_role
    role = Role.find_by(name: "3cx_api")
    if !role
      role = Role.create!(name: "3cx_api", permissions: [:use_api])
    end

    role
  end

  def create_sample_project
    project = FactoryBot.create(:project)
    puts("Created project: #{project}")
    project
  end

  def create_membership(account, project, role)
    Member.create!(user_id: account.id, project_id: project.id, roles: [role])
  end

  def create_service_account
    account = FactoryBot.create(:user, login: "service_account")
    puts("Created account: #{account}")
    puts("Service Account API Key:")
    puts(account.api_key)
    account
  end

  def create_contacts(project)
    [
      FactoryBot.create(:contact, first_name: "John", project:, phone: "+41 78 123 45 67"),
      FactoryBot.create(:contact, first_name: "Zoe", project:, phone: "078 111 22 33"),
      FactoryBot.create(:contact, first_name: "Henry", project:, phone: "+41 78 111 22 33")
    ]
  end
end
