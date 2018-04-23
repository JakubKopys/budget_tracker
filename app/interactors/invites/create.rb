# frozen_string_literal: true

module Invites
  class Create < ApplicationInteractor
    delegate :user, :household_id, :invitee_id, to: :context

    def call
      household = user.administrated_households.find household_id
      invitee = User.find invitee_id

      validate_form household: household, invitee: invitee

      invite = create_invite household: household, invitee: invitee

      context.result = { id: invite.id }
      context.status = :created
    end

    private

    def validate_form(household:, invitee:)
      form = InviteForm.new user: invitee, household: household
      stop form.errors, :unprocessable_entity unless form.validate
    end

    def create_invite(household:, invitee:)
      invitee.invites.create! household: household, expires_at: Time.current + 1.month
    end
  end
end
