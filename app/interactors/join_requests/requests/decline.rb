# frozen_string_literal: true

module JoinRequests
  module Requests
    class Decline < ApplicationInteractor
      delegate :user, :household_id, :request_id, to: :context

      def call
        household = user.administrated_households.find household_id
        request = household.pending_requests.find request_id

        request.decline!

        context.status = :no_content
      end
    end
  end
end
