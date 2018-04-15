# frozen_string_literal: true

class Household < ApplicationRecord
  MINIMUM_NAME_LENGTH = 4

  has_many :inmates, dependent: :destroy
  has_many :users, through: :inmates

  has_many :admin_inmates,
           -> { where is_admin: true },
           class_name: 'Inmate',
           inverse_of: :household
  has_many :admins, through: :admin_inmates, source: :user

  has_many :invites, dependent: :destroy
  has_many :requests, dependent: :destroy
end
