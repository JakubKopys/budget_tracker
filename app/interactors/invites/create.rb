# frozen_string_literal: true

module Invites
  class Create < ApplicationInteractor
    delegate :user, :household, to: :context

    def call
      validate_form

      invite = create_invite

      context.result = { id: invite.id }
      context.status = :created
    end

    private

    def validate_form
      form = InviteForm.new user: user, household: household
      stop form.errors, :unprocessable_entity unless form.validate
    end

    def create_invite
      user.invites.create! household: household, expires_at: Time.current + 1.month
    end
  end
end
