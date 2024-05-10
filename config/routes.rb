# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get "3cx/contacts", to: "crm_api#show", defaults: {format: "json"}
get "crm_template", to: "crm_template#index"
