# frozen_string_literal: true

module Api
  module V1
    class JoinRequests::InvitesController < ApplicationController
      def index
        call_params = {
          user: current_user,
          params: index_params
        }

        respond_with interactor: Invites::Index.call(call_params)
      end

      def create
        call_params = {
          invitee_id: params[:user_id].to_i,
          household_id: params[:household_id].to_i,
          user: current_user
        }

        respond_with interactor: Invites::Create.call(call_params)
      end

      def accept
        respond_with interactor: Invites::Accept.call(answer_params)
      end

      def decline
        respond_with interactor: Invites::Decline.call(answer_params)
      end

      private

      def index_params
        params.permit :household_id, :sort_by, :sort_id, :per_page, :page
      end

      def answer_params
        {
          user: current_user,
          invite_id: params[:id].to_i,
          household_id: params[:household_id].to_i
        }
      end
    end
  end
end
