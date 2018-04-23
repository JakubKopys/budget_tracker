# frozen_string_literal: true

module Invites
  class Create < ApplicationInteractor
    delegate :user, :household_id, :invitee_id, to: :context

    def call
      validate_form

      invite = create_invite

      context.result = { id: invite.id }
      context.status = :created
    end

    private

    def validate_form
      form = InviteForm.new user: invitee, household: household
      stop form.errors, :unprocessable_entity unless form.validate
    end

    def create_invite
      invitee.invites.create! household: household, expires_at: Time.current + 1.month
    end

    def household
      @household ||= user.administrated_households.find household_id
    end

    def invitee
      @invitee ||= User.find invitee_id
    end
  end
end
