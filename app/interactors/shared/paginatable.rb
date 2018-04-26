# frozen_string_literal: true

module Shared
  module Paginatable
    private

    def paginate(relation:)
      limit  = per_page.to_i
      offset = (page.to_i - 1) * limit

      context.pagination_data = pagination_data relation: relation

      relation.limit(limit).offset offset
    end

    def pagination_data(relation:)
      {
        page: page.to_i,
        pages: pages_count(relation: relation)
      }
    end

    def pages_count(relation:)
      (relation.count("#{relation.table_name}.*") / per_page.to_f).ceil
    end

    def per_page
      @per_page = params[:per_page] || 10
    end

    def page
      @page = params[:page] || 1
    end
  end
end
