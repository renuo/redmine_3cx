namespace :redmine_3cx do
  desc <<-DESC
    Setup service account and role for 3CX API access

    Creates:
      - Role '3cx_api' with :use_api permission
      - User '3cx_service_account' with API access
      - Memberships for all projects with contacts module enabled

    Example:
      rake redmine_3cx:setup_service_account
  DESC

  task setup_service_account: :environment do
    role = Role.find_or_create_by!(name: "3cx_api") { |r| r.permissions = [:use_api] }
    puts "Role: #{role.name} (id: #{role.id})"

    User.where(login: "3cx_service_account").destroy_all
    account = User.create!(
      login: "3cx_service_account",
      firstname: "3CX",
      lastname: "Service Account",
      mail: "3cx_service_account@localhost",
      admin: false,
      status: User::STATUS_ACTIVE
    )
    account.random_password
    account.save!
    puts "User: #{account.login} (id: #{account.id})"
    puts "API Key: #{account.api_key}"

    projects = Project.joins(:enabled_modules).where(enabled_modules: {name: "contacts"})
    projects.each do |project|
      Member.create!(user: account, project: project, roles: [role])
      puts "  Added to project: #{project.name}"
    end

    if projects.any?
      contact = Contact.joins(:projects).where(projects: {id: projects.pluck(:id)}).first
      if contact
        raise "Permission check failed" unless account.allowed_to?(:use_api, contact.project)
        puts "Permission check passed"
      else
        puts "No contacts found to verify permissions"
      end
    else
      puts "No projects with contacts module enabled"
    end

    puts "Setup complete!"
  end

  desc <<-DESC
    Lookup contacts by phone number

    Example:
      rake redmine_3cx:phone_lookup phone="+41 78 111 22 33"
      rake redmine_3cx:phone_lookup phone="+41 78 111 22 33" login="admin" host="myapp.example.com"
  DESC

  task phone_lookup: :environment do
    phone = ENV.fetch("phone") { abort "Error: Argument 'phone' is required" }
    call_api("/3cx/lookup.json?phone=#{URI.encode_uri_component(phone)}")
  end

  desc <<-DESC
    Search contacts by query

    Example:
      rake redmine_3cx:contact_search query="John"
      rake redmine_3cx:contact_search query="John" login="admin" host="myapp.example.com"
  DESC

  task contact_search: :environment do
    query = ENV.fetch("query") { abort "Error: Argument 'query' is required" }
    call_api("/3cx/search.json?query=#{URI.encode_uri_component(query)}")
  end

  def call_api(path)
    require 'uri'
    require 'net/http'

    host = ENV.fetch("host", "localhost:3000")
    login = ENV.fetch("login", "3cx_service_account")
    url = URI("http://#{host}#{path}")

    user = User.find_by(login:)
    abort "Error: User '#{login}' not found" unless user

    http = Net::HTTP.new(url.host, url.port)
    request = Net::HTTP::Get.new(url)
    request["authorization"] = "Basic #{Base64.encode64("#{user.api_key}:x").chomp}"

    response = http.request(request)

    unless response.is_a?(Net::HTTPSuccess)
      abort "Error: Request failed with status #{response.code} #{response.message}\n#{response.body}"
    end

    begin
      json = JSON.parse(response.body)
      puts JSON.pretty_generate(json)
    rescue JSON::ParserError => e
      abort "Error: Invalid JSON response\n#{response.body}\n#{e.message}"
    end
  end
end
