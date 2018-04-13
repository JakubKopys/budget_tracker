# frozen_string_literal: true

module Households
  class BasicForm < ApplicationForm
    BASE_ATTRIBUTES = %i[name].freeze

    validates :name, length: { minimum: Household::MINIMUM_NAME_LENGTH }
  end
end
