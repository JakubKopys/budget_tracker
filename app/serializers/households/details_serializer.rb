# frozen_string_literal: true

module Households
  class DetailsSerializer < ActiveModel::Serializer
    attributes :id, :name
  end
end
