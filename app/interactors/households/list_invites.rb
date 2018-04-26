# frozen_string_literal: true

module Households
  class ListInvites < ApplicationInteractor
    include Shared::Paginatable
    include Shared::Sortable

    delegate :params, :user, to: :context

    def call
      household = user.administrated_households.find params[:id]

      invites = household.pending_invites
      invites = sort relation: invites
      invites = paginate relation: invites

      context.result =
        ActiveModel::Serializer::CollectionSerializer.new(
          invites,
          serializer: Invites::ListSerializer
        ).as_json
    end
  end
end
