FactoryBot.define do
  factory :user do
    first_name "John"
    last_name  "Doe"
    password   "supersecret"
    sequence :email do |n|
      "user#{n}@email.com"
    end
  end
end
