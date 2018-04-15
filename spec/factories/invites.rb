# frozen_string_literal: true

FactoryBot.define do
  factory :invite do
    association :invitee, factory: :user
    household
  end
end
