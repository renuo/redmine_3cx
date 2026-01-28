namespace :redmine_3cx do
  desc "Upload contacts CSV to 3CX phonebook (requires RAILS_ENV=test)"
  task update_phonebook: :environment do
    require "capybara"
    require "capybara/dsl"
    require "selenium-webdriver"

    updater = Object.new
    updater.extend(Capybara::DSL)

    base_url = ENV.fetch("THREE_CX_URL")
    email = ENV.fetch("THREE_CX_EMAIL")
    password = ENV.fetch("THREE_CX_PASSWORD")
    csv_file_path = "tmp/contacts.csv"

    # Setup Capybara
    Capybara.register_driver :selenium_chrome_headless do |app|
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument("--headless=new")
      options.add_argument("--disable-gpu")
      options.add_argument("--no-sandbox")
      options.add_argument("--disable-dev-shm-usage")
      options.add_argument("--window-size=1920,1080")

      Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
    end

    Capybara.default_driver = :selenium_chrome_headless
    Capybara.default_max_wait_time = 30
    Capybara.app_host = base_url
    Capybara.run_server = false

    begin
      # Validate CSV exists
      raise "CSV file not found at #{csv_file_path}. Run 'rake redmine_3cx:export' first." unless File.exist?(csv_file_path)

      # Login
      puts "Logging in to 3CX..."
      updater.visit "/#/login"
      updater.fill_in "Email", with: email
      updater.fill_in "Password", with: password
      updater.click_button "Login"
      raise "Login failed - still on login page" unless updater.has_no_css?('input[name="Email"]', wait: 30)
      puts "Login successful!"

      # Navigate to contacts
      puts "Navigating to contacts..."
      updater.visit "/#/office/system/contacts"
      raise "Contacts page failed to load" unless updater.has_css?("button span", text: "Import", wait: 30)
      puts "Contacts page loaded!"

      # Import CSV
      puts "Importing CSV..."
      updater.find("button span", text: "Import").ancestor("button").click
      raise "File upload dialog did not appear" unless updater.has_css?('input[type="file"]', visible: :all, wait: 10)

      csv_path = File.expand_path(csv_file_path)
      updater.find('input[type="file"]', visible: :all).attach_file(csv_path)

      # Verify import
      puts "Verifying import..."
      raise "Expected to find 'Done' on page" unless updater.has_text?("Done", wait: 30)
      raise "Expected to find 'Contacts have been imported' on page" unless updater.has_text?("Contacts have been imported", wait: 30)

      puts "Contacts have been imported successfully!"
    ensure
      Capybara.reset_sessions!
    end
  end
end
