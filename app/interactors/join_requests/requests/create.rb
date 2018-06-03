# frozen_string_literal: true

module JoinRequests
  module Request
    class Create < ApplicationInteractor
      delegate :user, :household_id, to: :context

      def call
        household = Household.find(household_id)

        validate_form(household: household, user: user)

        request = user.reqests.create household: household

        context.result = { id: request.id }
        context.status = :created
      end

      private

      def validate_form(household:, user:)
        form = CreateForm.new user: user, household: household
        stop form.errors, :unprocessable_entity unless form.validate
      end
    end
  end
end
