# frozen_string_literal: true

module Invites
  class Index < ApplicationInteractor
    include Shared::Paginatable
    include Shared::Sortable

    delegate :user, :household_id, to: :context

    def call
      household = user.administrated_households.find household_id

      invites = household.pending_invites
      invites = sort relation: invites
      invites = paginate relation: invites

      ActiveModel::Serializer::CollectionSerializer.new(
        invites,
        serializer: ListSerializer
      ).as_json
    end
  end
end
