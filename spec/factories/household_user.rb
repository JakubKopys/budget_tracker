# frozen_string_literal: true

FactoryBot.define do
  factory :household_user do
    user
    household

    factory :admin_household_user do
      is_admin true
    end
  end
end
