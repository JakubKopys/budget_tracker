# frozen_string_literal: true

module JoinRequests
  module Invites
    class Decline < ApplicationInteractor
      delegate :user, :invite_id, to: :context

      def call
        invite = user.pending_invites.find invite_id

        invite.decline!

        context.status = :no_content
      end
    end
  end
end
