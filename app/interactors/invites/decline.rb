# frozen_string_literal: true

module Invites
  class Decline < ApplicationInteractor
    delegate :user, :household_id, :invite_id, to: :context

    def call
      household = user.administrated_households.find household_id
      invite = household.invites.find invite_id

      invite.decline!

      context.status = :no_content
    end
  end
end
