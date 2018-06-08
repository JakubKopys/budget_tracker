# frozen_string_literal: true

module JoinRequests
  module Requests
    class Accept < ApplicationInteractor
      delegate :user, :household_id, :request_id, to: :context

      def call
        household = user.administrated_households.find household_id
        request = household.pending_requests.find request_id

        accept_request!(household: household, request: request)

        context.status = :no_content
      end

      private

      def accept_request!(household:, request:)
        Request.transaction do
          household.household_users.build user_id: request.invitee_id
          household.save!
          request.accept!
        end
      end
    end
  end
end
