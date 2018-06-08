# frozen_string_literal: true

module JoinRequests
  module Invites
    class Accept < ApplicationInteractor
      delegate :user, :household_id, :invite_id, to: :context

      def call
        household = Household.find household_id
        invite = user.pending_invites.find invite_id

        accept_invite!(household: household, invite: invite)

        context.status = :no_content
      end

      private

      def accept_invite!(household:, invite:)
        Invite.transaction do
          household.household_users.build user_id: user.id
          household.save!
          invite.accept!
        end
      end
    end
  end
end
