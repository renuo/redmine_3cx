# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

scope "3cx" do
  get "contacts", to: "crm_api#index", defaults: {format: "json"}
  get "template", to: "crm_template#show", defaults: {format: "xml"}
end
