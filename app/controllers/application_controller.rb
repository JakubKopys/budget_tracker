class ApplicationController < ActionController::Base
  attr_reader :current_user
  before_action :authenticate_user!

  private

  def authenticate_user!
    set_user_from_header
  rescue Users::Authentication::Error => error
    json_api_error_hash = { errors: { authorization: error.message } }
    render json: json_api_error_hash, status: :unauthorized
  end

  def authenticate_user
    set_user_from_header
  rescue Users::Authentication::Error
    nil
  end

  def set_user_from_header
    auth_header   = request.headers['Authorization']
    @current_user = Users::Authentication.authenticate header: auth_header
  end

  def respond_with(interactor:)
    if interactor.success?
      success_response interactor
    else
      error_response interactor
    end
  end

  def success_response(interactor)
    if interactor.result
      render json: interactor.result, status: interactor.status
    else
      head interactor.status
    end
  end

  def error_response(interactor)
    if interactor.errors
      errors_json = { errors: interactor.errors.details }
      render json: errors_json, status: interactor.status
    else
      head interactor.status
    end
  end
end
