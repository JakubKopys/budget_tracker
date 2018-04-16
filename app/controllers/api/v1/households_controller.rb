# frozen_string_literal: true

module Api
  module V1
    class HouseholdsController < ApplicationController
      before_action :authorize_user, only: [:update]

      def create
        # TODO: add users_ids, create invites for these users?
        respond_with interactor: Households::Create.call(household_params)
      end

      def update
        update_params = household_params.merge id: params[:id]
        respond_with interactor: Households::Update.call(update_params)
      end

      private

      def authorize_user
        return if Inmate.where(user_id: current_user.id, household_id: params[:id],
                               is_admin: true).exists?

        render json: { errors: 'Only admins can update household information' },
               status: :forbidden
      end

      def household_params
        params.require(:household).permit(:name).merge user: current_user
      end
    end
  end
end
