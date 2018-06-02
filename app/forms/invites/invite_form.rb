# frozen_string_literal: true

module Invites
  class InviteForm < ApplicationForm
    ATTRIBUTES = %i[user household].freeze

    attr_accessor(*ATTRIBUTES)

    validates :user, :household, presence: true
    validate :household_residents_exclusion

    private

    def household_residents_exclusion
      if HouseholdUser.exists? user: user, household: household
        errors.add :user, 'is already an household resident'
      else
        true
      end
    end
  end
end
