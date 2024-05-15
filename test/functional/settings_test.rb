require_relative "../test_helper"

class SettingsTest < ActionController::TestCase
  include FactoryBot::Syntax::Methods

  fixtures :roles, :users

  def setup
    Setting.rest_api_enabled = "1"
    Setting[:plugin_redmine_3cx] = {active: true}
    project = create(:project)
    project.enable_module! :contacts
  end

  def test_settings_page
    @request.session[:user_id] = 1
    get "settings/plugin/redmine_3cx"
  end
end
