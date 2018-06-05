# frozen_string_literal: true

module JoinRequests
  module Requests
    class Create < ApplicationInteractor
      delegate :user, :household_id, to: :context

      def call
        household = Household.find(household_id)

        validate_form(household: household, user: user)

        request = create_request(household: household, user: user)

        context.result = { id: request.id }
        context.status = :created
      end

      private

      def validate_form(household:, user:)
        form = CreateForm.new user: user, household: household
        stop form.errors, :unprocessable_entity unless form.validate
      end

      def create_request(user:, household:)
        user.requests.create household: household,
                             expires_at: Time.current + JoinRequest::PERIOD_OF_VALIDITY
      end
    end
  end
end
