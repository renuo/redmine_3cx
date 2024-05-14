Redmine::Plugin.register :redmine_3cx do
  name "Redmine 3CX Plugin"
  author "Daniel Bengl"
  description "A simple 3CX integration plugin."
  version "0.4.0"
  url "https://github.com/renuo/redmine_3cx"
  author_url "https://github.com/CuddlyBunion341"
  project_module :contacts do
    permission :use_api, {crm_api: :index}, read: true
  end
end
