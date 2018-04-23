# frozen_string_literal: true

module Shared
  module Sortable
    private

    def sort(relation:, sort_by: params[:sort_by], sort_dir: params[:sort_dir])
      return relation unless sort_by

      direction = sort_dir&.downcase == 'asc' ? 'asc' : 'desc'
      column    = sort_by

      return relation unless relation.model.attribute_names.include? column
      relation.order "#{column} #{direction} NULLS LAST"
    end
  end
end
