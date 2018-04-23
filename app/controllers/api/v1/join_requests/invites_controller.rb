# frozen_string_literal: true

module Api
  module V1
    class JoinRequests::InvitesController < ApplicationController
      def create
        user = User.find params[:user_id]
        household = current_user.administrated_households.find params[:household_id]
        respond_with interactor: Invites::Create.call(user: user, household: household)
      end

      def accept
        respond_with interactor: Invites::Accept.call(invite_params)
      end

      def decline
        respond_with interactor: Invites::Decline.call(invite_params)
      end

      private

      def invite_params
        {
          user: current_user,
          invite_id: params[:id].to_i,
          household_id: params[:household_id].to_i
        }
      end
    end
  end
end
