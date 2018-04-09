# frozen_string_literal: true

module Users
  class BasicForm < ApplicationForm
    BASE_ATTRIBUTES = %i(email first_name last_name password).freeze
    EMAIL_REGEXP = /\A[^@\s]+@[^@\s]+\z/

    validates :password,
              length: { minimum: User::MINIMUM_PASSWORD_LENGTH },
              allow_blank: true
    validates :email, format: { with: EMAIL_REGEXP }, if: :email
    validate :unique_email, if: :email

    private

    def unique_email
      @user ||= User.new

      if User.where.not(id: @user.id).exists? email: email
        errors.add :email, 'is taken'
      else
        true
      end
    end
  end
end
