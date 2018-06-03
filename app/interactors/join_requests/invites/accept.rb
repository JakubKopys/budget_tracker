# frozen_string_literal: true

module JoinRequests
  module Invites
    class Accept < ApplicationInteractor
      delegate :user, :household_id, :invite_id, to: :context

      def call
        accept_invite!

        context.status = :no_content
      end

      private

      def accept_invite!
        Invite.transaction do
          household.household_users.build user_id: invite.invitee_id
          household.save!
          invite.accept!
        end
      end

      def household
        @household ||= user.administrated_households.find household_id
      end

      def invite
        @invite ||= household.pending_invites.find invite_id
      end
    end
  end
end
