# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authenticate_user!, only: [:create]
      before_action :authorize_user, only: [:update]

      def create
        respond_with interactor: Users::Register.call(create_params)
      end

      def update
        respond_with interactor: Users::Update.call(update_params.merge id: params[:id])
      end

      private

      def authorize_user
        return true if current_user.id == params[:id].to_i

        render json: { errors: 'You can only access your own profile' },
                     status: :forbidden
      end

      def user_params
        params.require(:user).permit(:email, :first_name, :last_name, :password)
      end

      alias_method :create_params, :user_params
      alias_method :update_params, :user_params
    end
  end
end
