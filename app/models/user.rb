# frozen_string_literal: true

class User < ApplicationRecord
  MINIMUM_PASSWORD_LENGTH = 6
  has_secure_password
end
