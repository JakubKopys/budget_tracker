# frozen_string_literal: true

module Invites
  class Index < ApplicationInteractor
    include Shared::Paginatable
    include Shared::Sortable

    delegate :params, :user, to: :context

    def call
      household = user.administrated_households.find params[:household_id]

      invites = household.pending_invites
      invites = sort relation: invites
      invites = paginate relation: invites

      context.result =
        ActiveModel::Serializer::CollectionSerializer.new(
          invites,
          serializer: ListSerializer
        ).as_json
    end
  end
end
