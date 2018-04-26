# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authenticate_user!, only: [:create]
      before_action :authorize_user, only: [:update]

      def create
        respond_with interactor: Users::Register.call(user_params)
      end

      def update
        respond_with interactor: Users::Update.call(user_params.merge(id: params[:id]))
      end

      def invites
        call_params = {
          user: current_user,
          params: invites_params
        }

        respond_with interactor: Users::ListInvites.call(call_params)
      end

      private

      def authorize_user
        return true if current_user.id == params[:id].to_i

        render json: { errors: 'You can only access your own profile' },
               status: :forbidden
      end

      def invites_params
        params.permit :sort_by, :sort_id, :per_page, :page
      end

      def user_params
        params.require(:user).permit :email, :first_name, :last_name, :password
      end
    end
  end
end
