# This will guess the User class
FactoryBot.define do
  factory :poll do
    question { "Does ruby rock?" }
    yes { 42 }
    no { 0 }
  end
end
