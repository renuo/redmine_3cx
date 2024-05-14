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
    phone { "+41 78 123 45 67" }
  end
end
