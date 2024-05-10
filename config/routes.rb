# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get "3cx/contacts", to: "crm_api#show", defaults: {format: "json"}
get "3cx/template", to: "crm_template#index"
