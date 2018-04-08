module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user!, except: [:create]

      def create
        respond_with interactor: Users::Register.call(create_params)
      end

      private

      def create_params
        params.require(:user).permit(:email, :first_name, :last_name, :password)
      end
    end
  end
end
