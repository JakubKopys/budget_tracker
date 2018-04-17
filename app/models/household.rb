# frozen_string_literal: true

class Household < ApplicationRecord
  MINIMUM_NAME_LENGTH = 4

  has_many :household_users, dependent: :destroy
  has_many :users, through: :household_users

  has_many :admin_household_users,
           -> { where is_admin: true },
           class_name: 'HouseholdUser',
           inverse_of: :household
  has_many :admins, through: :admin_household_users, source: :user

  has_many :invites, dependent: :destroy
  has_many :requests, dependent: :destroy
end
