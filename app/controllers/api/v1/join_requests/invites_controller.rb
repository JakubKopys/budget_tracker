# frozen_string_literal: true

module Api
  module V1
    class JoinRequests::InvitesController < ApplicationController
      def index
        # TODO: implement
        raise NotImplementedError
      end

      def create
        # TODO: move these finds to interactor
        user = User.find params[:user_id]
        household = current_user.administrated_households.find params[:household_id]
        respond_with interactor: Invites::Create.call(user: user, household: household)
      end

      # TODO: test accept/decline
      def accept
        respond_with interactor: Invites::Accept.call(invite_params)
      end

      def decline
        raise NotImplementedError
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
