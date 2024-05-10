# This will guess the User class
FactoryBot.define do
  factory :project do
    name { "Project" }
    identifier { "my_project" }
  end
  factory :contact do
    association :project
    first_name { "John" }
    last_name { "Doe" }
    company { "Example AG" }
    phone { "1234567890" }
  end
end
