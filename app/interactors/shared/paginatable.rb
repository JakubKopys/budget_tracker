# frozen_string_literal: true

module Shared
  module Paginatable
    private

    def paginate(relation:)
      limit  = params[:per_page].to_i
      offset = (params[:page].to_i - 1) * limit

      context.pagination_data = pagination_data relation: relation

      relation.limit(limit).offset offset
    end

    def pagination_data(relation:)
      {
        page: params[:page].to_i,
        pages: pages_count(relation: relation)
      }
    end

    def pages_count(relation:)
      (relation.count("#{relation.table_name}.*") / params[:per_page].to_f).ceil
    end
  end
end
