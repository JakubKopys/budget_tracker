# frozen_string_literal: true

module Api
  module V1
    class JoinRequests::RequestsController < ApplicationController
      def create
        call_params = {
          user: current_user,
          household_id: params[:household_id].to_i
        }

        respond_with interactor: ::JoinRequests::Requests::Create.call(call_params)
      end
    end
  end
end
