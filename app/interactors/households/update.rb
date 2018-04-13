# frozen_string_literal: true

module Households
  class Update < ApplicationInteractor
    delegate :user, :name, :id, to: :context

    def call
      # TODO: authorize, only admins can update household
      household = Household.find id
      validate_form
      update_household household

      context.result = household.as_json only: %i[id name]
    end

    private

    def validate_form
      form = UpdateForm.new name: name
      stop form.errors, :unprocessable_entity unless form.validate
    end

    def update_household(household)
      household.update! name: name
    end
  end
end
