# frozen_string_literal: true

require 'users/authentication'

module Users
  class Login < ApplicationInteractor
    def call
      user = find_user
      validate user

      token = Authentication.create_token user_id: user.id

      context.result = { user_id: user.id, token: token }
      context.status = :ok
    end

    private

    def find_user
      User.find_by email: context.email if context.email.present?
    end

    def validate(user)
      stop user_error, :not_found unless user
      stop password_error, :not_found unless user.authenticate context.password
    end

    def user_error
      Error.new 'User with given credentials not found.'
    end

    def password_error
      Error.new 'Password is invalid.'
    end
  end
end
