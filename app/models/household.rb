# frozen_string_literal: true

class Household < ApplicationRecord
  has_many :inmates, dependent: :destroy
  has_many :users, through: :inmates

  has_many :admin_inmates,
           -> { where is_admin: true },
           class_name: 'Inmate',
           inverse_of: :household
  has_many :admins, through: :admin_inmates, source: :user
end
