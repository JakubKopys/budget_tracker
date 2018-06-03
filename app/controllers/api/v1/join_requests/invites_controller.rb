# frozen_string_literal: true

module Api
  module V1
    class JoinRequests::InvitesController < ApplicationController
      def create
        call_params = {
          invitee_id: params[:user_id].to_i,
          household_id: params[:household_id].to_i,
          user: current_user
        }

        respond_with interactor: ::JoinRequests::Invites::Create.call(call_params)
      end

      def accept
        respond_with interactor: ::JoinRequests::Invites::Accept.call(answer_params)
      end

      def decline
        respond_with interactor: ::JoinRequests::Invites::Decline.call(answer_params)
      end

      private

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
