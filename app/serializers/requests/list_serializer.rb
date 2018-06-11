# frozen_string_literal: true

module Requests
  class ListSerializer < ActiveModel::Serializer
    attributes :id, :expires_at

    belongs_to :household, serializer: Households::DetailsSerializer
    belongs_to :invitee, serializer: Users::ProfileSerializer
  end
end
