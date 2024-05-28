require_relative "../test_helper"
require_relative "../../../../test/application_system_test_case"

# The CI is not configured to run capybara tests at the moment
return if ENV["CI"] == "true"

class SettingsTest < ApplicationSystemTestCase
  include FactoryBot::Syntax::Methods

  fixtures :roles, :users

  def setup
    Setting.rest_api_enabled = "1"
    Setting[:plugin_redmine_3cx] = {active: true}
    project = create(:project)
    project.enable_module! :contacts
  end

  def test_settings_page
    log_user("admin", "admin")

    check_plugin_form

    assert page.has_content?("Redmine Contacts is installed.")
    assert page.has_content?("API authentication is active.")
    assert page.has_content?("Plugin is compatible with Redmine Contacts")

    Contact.stub :new, nil do
      visit_settings_page
      assert page.has_content?("Plugin is not compatible with Redmine Contacts")
    end

    Redmine::Plugin.stub :installed?, false do
      visit_settings_page
      assert page.has_content?("Redmine Contacts is not installed.")
    end

    Setting.stub :rest_api_enabled?, false do
      visit_settings_page
      assert page.has_content?("Please active API authentication")
      click_on "API Settings"
      assert_equal "/settings", current_path
      assert page.has_content?("Enable REST web service")
    end
  end

  private

  def check_plugin_form
    visit_settings_page

    assert_active_state(true)
    uncheck "settings[active]"
    click_on "Apply"
    assert_active_state(nil)
  end

  def assert_active_state(state)
    Setting.clear_cache
    assert_equal state, Setting.plugin_redmine_3cx[:active]
  end

  def visit_settings_page
    visit "settings/plugin/redmine_3cx"
  end
end
