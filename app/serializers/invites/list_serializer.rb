# frozen_string_literal: true

module Invites
  class ListSerializer < ActiveModel::Serializer
    attributes :id, :expiry_date

    belongs_to :household, serializer: Households::DetailsSerializer
    belongs_to :invitee, serializer: Users::ProfileSerializer
  end
end
