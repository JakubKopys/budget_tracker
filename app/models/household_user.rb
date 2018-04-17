# frozen_string_literal: true

class HouseholdUser < ApplicationRecord
  belongs_to :user, inverse_of: :household_users
  belongs_to :household, inverse_of: :household_users
end
