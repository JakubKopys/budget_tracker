# frozen_string_literal: true

module Households
  class UpdateForm < BasicForm
    ATTRIBUTES = BASE_ATTRIBUTES

    attr_accessor(*ATTRIBUTES)
  end
end
