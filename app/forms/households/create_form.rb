# frozen_string_literal: true

module Households
  class CreateForm < BasicForm
    ADDITIONAL_ATTRIBUTES = %i[user].freeze
    ATTRIBUTES = (BASE_ATTRIBUTES + ADDITIONAL_ATTRIBUTES).freeze

    validates :user, presence: true

    attr_accessor(*ATTRIBUTES)
  end
end
