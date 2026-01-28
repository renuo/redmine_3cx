FactoryBot.define do
  factory :user do
    login { "myuser" }
    password { "password" }
    mail { "example@example.com" }
    firstname { "John" }
    lastname { "Knolastname" }
  end

  factory :project do
    sequence :identifier do |n|
      "my_project#{n}"
    end
    name { "Project" }
    enabled_module_names { [:contacts] }
  end

  factory :contact do
    association :project
    first_name { "John" }
    last_name { "Doe" }
    company { "Example AG" }
    phone { "+41 78 123 45 67" }
  end
end
