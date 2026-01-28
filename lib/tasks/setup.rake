namespace :redmine_3cx do
  desc "Enable Plugin"
  task enable_plugin: :environment do
    Setting.create(name: "plugin_redmine_3cx", value: {active: true}.with_indifferent_access)
    Setting.rest_api_enabled = "1"
    assert!(Setting["plugin_redmine_3cx"]["active"] == true, "Expected Plugin to be enabled")
    assert!(Setting.rest_api_enabled?, "Expected REST API to be enabled")
    puts("Success!")
  end

  def assert!(condition, message)
    if !condition
      raise message
    end

    condition
  end
end
