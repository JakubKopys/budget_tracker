# frozen_string_literal: true

FactoryBot.define do
  factory :request do
    association :invitee, factory: :user
    household
    expires_at { Time.current + 1.week }

    factory :pending_request do
      state 'pending'
    end
  end
end
