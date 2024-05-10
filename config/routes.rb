# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get "3cx_contacts", to: "crm_api#show", defaults: {format: "json"}
