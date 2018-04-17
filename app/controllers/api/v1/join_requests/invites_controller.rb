# frozen_string_literal: true

module Api
  module V1
    class JoinRequests::InvitesController < ApplicationController
      before_action :authorize_user

      def create
        user = User.find params[:user_id]
        household = Household.find params[:household_id]
        respond_with interactor: Invites::Invite.call(user: user, household: household)
      end

      def update
        raise NotImplementedError
      end

      def destroy
        raise NotImplementedError
      end

      private

      def authorize_user
        return if HouseholdUser.where(user_id: current_user.id,
                                      household_id: params[:household_id],
                                      is_admin: true).exists?

        render json: { errors: 'Only admins can invite users.' },
               status: :forbidden
      end
    end
  end
end
