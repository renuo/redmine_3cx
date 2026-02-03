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
end
