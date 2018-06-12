# frozen_string_literal: true

module Households
  class ListRequests < ApplicationInteractor
    include Shared::Paginatable
    include Shared::Sortable

    delegate :params, :user, to: :context

    def call
      household = user.administrated_households.find params[:id]

      requests = household.pending_requests
      requests = sort relation: requests
      requests = paginate relation: requests

      context.result =
        ActiveModel::Serializer::CollectionSerializer.new(
          requests,
          serializer: Requests::ListSerializer
        ).as_json
    end
  end
end
