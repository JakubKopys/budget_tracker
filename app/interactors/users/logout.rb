# frozen_string_literal: true
require 'users/authentication'

module Users
  class Logout < ApplicationInteractor
    def call
      token = Authentication.token_from_header context.auth_header
      ExpiredToken.create token: token, expires_at: Time.current
      context.status = :no_content
    end
  end
end
