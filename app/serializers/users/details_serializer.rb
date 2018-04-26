# frozen_string_literal: true

module Users
  class DetailsSerializer < ActiveModel::Serializer
    attributes :id, :first_name, :last_name, :email

    has_many :pending_invites, serializer: Invites::ListSerializer
  end
end
