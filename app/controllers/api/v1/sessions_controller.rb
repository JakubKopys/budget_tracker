module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :authenticate_user!, only: [:create]

      def create
        respond_with interactor: Users::Login.call(session_params)
      end

      private

      def session_params
        params.require(:user).permit(:email, :password)
      end
    end
  end
end
