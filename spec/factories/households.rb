# frozen_string_literal: true

FactoryBot.define do
  factory :household do
    sequence :name do |n|
      "Household#{n}"
    end

    factory :household_with_admin do
      after(:create) do |household|
        create :admin_household_user, household: household
      end
    end
  end
end
