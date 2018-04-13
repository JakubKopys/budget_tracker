# frozen_string_literal: true

module Households
  class Create < ApplicationInteractor
    delegate :user, :name, to: :context

    def call
      validate_form

      household = create_household

      context.result = { household: household }
      context.status = :created
    end

    private

    def validate_form
      form = CreateForm.new user: user, name: name
      stop form.errors, :unprocessable_entity unless form.validate
    end

    def create_household
      user.administrated_households.create! name: name
    end
  end
end
