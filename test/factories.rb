# This will guess the User class
FactoryBot.define do
  factory :project do
    sequence :identifier do |n|
      "my_project#{n}"
    end
    name { "Project" }
  end
  factory :contact do
    association :project
    first_name { "John" }
    last_name { "Doe" }
    company { "Example AG" }
    phone { "+41 78 123 45 67" }
  end
end
