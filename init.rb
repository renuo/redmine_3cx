# require_dependency File.expand_path("lib/polls_hook_listener", __dir__)

Redmine::Plugin.register :redmine_3cx do
  name "3CX Plugin Redmine"
  author "Daniel Bengl"
  description "A simple 3CX integration plugin."
  version "0.0.1"
  url "https://github.com/renuo/redmine_3cx"
  author_url "http://example.com/about"
  menu :application_menu, :polls, {controller: "polls", action: "index"}, caption: "Polls"
  permission :polls, {polls: [:index, :vote]}, public: true
  menu :project_menu, :polls, {controller: "polls", action: "index"}, caption: "Polls", after: :activity, param: :project_id
  delete_menu_item :top_menu, :my_page
  delete_menu_item :top_menu, :help
  delete_menu_item :project_menu, :overview
  delete_menu_item :project_menu, :activity
  delete_menu_item :project_menu, :news
  permission :view_polls, polls: :index
  permission :vote_polls, polls: :vote
  project_module :polls do
    permission :view_polls, polls: :index
    permission :vote_polls, polls: :vote
  end
  settings default: {"empty" => true}, partial: "settings/poll_settings"
end
