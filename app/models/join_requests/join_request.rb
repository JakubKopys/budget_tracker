# frozen_string_literal: true

class JoinRequest < ApplicationRecord
  include AASM
  belongs_to :household

  aasm column: :state do
    state :pending, initial: true
    state :accepted
    state :declined
    state :expired

    event :accept do
      transitions from: :pending, to: :accepted
    end

    event :decline do
      transitions from: :pending, to: :declined
    end

    event :expire do
      transitions from: :pending, to: :expired
    end
  end
end
