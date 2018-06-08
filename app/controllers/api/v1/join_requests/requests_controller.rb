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

      def accept
        respond_with interactor: ::JoinRequests::Requests::Accept.call(answer_params)
      end

      def decline
        respond_with interactor: ::JoinRequests::Requests::Decline.call(answer_params)
      end

      private

      def answer_params
        {
          user: current_user,
          request_id: params[:id].to_i,
          household_id: params[:household_id].to_i
        }
      end
    end
  end
end
