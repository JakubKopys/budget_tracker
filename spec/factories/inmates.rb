# frozen_string_literal: true

FactoryBot.define do
  factory :inmate do
    user
    household

    factory :admin_inmate do
      is_admin true
    end
  end
end
