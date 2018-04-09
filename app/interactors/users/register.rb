# frozen_string_literal: true
require 'users/authentication'

module Users
  class Register < ApplicationInteractor
    def call
      validate_form
      user = create_user

      context.result = { user_id: user.id, token: create_token(user: user) }
      context.status = :created
    end

    private

    def form_params
      RegisterForm::ATTRIBUTES.each_with_object({}) do |form_attribute, hash|
        hash[form_attribute] = context.public_send(form_attribute)
      end
    end

    def validate_form
      form = RegisterForm.new form_params
      stop form.errors, :unprocessable_entity unless form.validate
    end

    def permitted_params
      form_params
    end

    def create_user
      User.new(permitted_params).tap(&:save!)
    end

    def create_token(user:)
      Authentication.create_token user_id: user.id
    end
  end
end
