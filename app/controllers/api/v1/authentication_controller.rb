module Api
  module V1
    class AuthenticationController < ApplicationController
      skip_before_action :authenticate_user!, only: [:create]

      def create
        respond_with interactor: Users::Login.call(login_params)
      end

      private

      def login_params
        params.permit(:email, :password)
      end
    end
  end
end
