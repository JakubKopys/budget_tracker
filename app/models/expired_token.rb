# frozen_string_literal: true

class ExpiredToken < ApplicationRecord
  validates :token, :expires_at, presence: true
end
