# frozen_string_literal: true

module Invites
  class InviteForm < ApplicationForm
    ATTRIBUTES = %i[user household].freeze

    attr_accessor(*ATTRIBUTES)

    validates :user, :household, presence: true
    validate :cant_be_household_resident

    private

    def cant_be_household_resident
      return unless household.household_users.pluck(:user_id).include? user.id

      errors.add :user, "can't invite user that is already an household resident"
    end
  end
end
