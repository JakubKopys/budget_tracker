# frozen_string_literal: true

FactoryBot.define do
  factory :invite do
    association :invitee, factory: :user
    household
    expires_at { Time.current + 1.week }

    factory :pending_invite do
      state 'pending'
    end
  end
end
