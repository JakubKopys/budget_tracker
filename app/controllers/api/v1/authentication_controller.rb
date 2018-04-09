# frozen_string_literal: true

module Api
  module V1
    class AuthenticationController < ApplicationController
      skip_before_action :authenticate_user!, only: [:create]

      def create
        respond_with interactor: Users::Login.call(login_params)
      end

      def destroy
        respond_with interactor: Users::Logout.call(logout_params)
      end

      private

      def login_params
        params.permit(:email, :password)
      end

      def logout_params
        { auth_header: request.headers['Authorization'] }
      end
    end
  end
end
