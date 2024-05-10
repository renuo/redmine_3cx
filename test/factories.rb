# This will guess the User class
FactoryBot.define do
  factory :contact do
    firstname { "John" }
    lastname { "Doe" }
    phone { "1234567890" }
  end
end
