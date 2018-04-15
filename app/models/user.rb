# frozen_string_literal: true

class User < ApplicationRecord
  MINIMUM_PASSWORD_LENGTH = 6
  has_secure_password validations: false

  has_many :inmates, dependent: :destroy
  has_many :households, through: :inmates

  has_many :admin_inmates,
           -> { where is_admin: true },
           class_name: 'Inmate',
           inverse_of: :user
  has_many :administrated_households, through: :admin_inmates, source: :household

  has_many :invites, foreign_key: :invitee_id, inverse_of: :invitee, dependent: :destroy
  has_many :requests, foreign_key: :invitee_id, inverse_of: :invitee, dependent: :destroy
end
