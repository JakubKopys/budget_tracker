# frozen_string_literal: true

class User < ApplicationRecord
  MINIMUM_PASSWORD_LENGTH = 6
  has_secure_password validations: false

  has_many :household_users, dependent: :destroy
  has_many :households, through: :household_users

  has_many :admin_household_users,
           -> { where is_admin: true },
           class_name: 'HouseholdUser',
           inverse_of: :user
  has_many :administrated_households, through: :admin_household_users,
                                      source: :household

  has_many :invites, foreign_key: :invitee_id, inverse_of: :invitee, dependent: :destroy
  has_many :pending_invites,
           -> { where state: 'pending' },
           class_name: 'Invite',
           foreign_key: :invitee_id,
           inverse_of: :invitee

  has_many :requests, foreign_key: :invitee_id, inverse_of: :invitee, dependent: :destroy
end
