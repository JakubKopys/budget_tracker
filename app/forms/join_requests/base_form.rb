# frozen_string_literal: true

module JoinRequests
  class BaseForm < ApplicationForm
    ATTRIBUTES = %i[user household].freeze

    attr_accessor(*ATTRIBUTES)

    validates :user, :household, presence: true
    validate :join_request_uniqueness
    validate :household_residents_exclusion

    private

    def household_residents_exclusion
      if HouseholdUser.exists? user: user, household: household
        errors.add :user, 'is already an household resident'
      else
        true
      end
    end

    def join_request_uniqueness
      @user ||= User.new

      if JoinRequest.exists? invitee_id: @user.id, household: household
        errors.add :base, 'such join request already exists'
      else
        true
      end
    end
  end
end
