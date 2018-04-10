# frozen_string_literal: true

class Household < ApplicationRecord
  has_many :inmates, dependent: :destroy
  has_many :users, through: :inmates
end
