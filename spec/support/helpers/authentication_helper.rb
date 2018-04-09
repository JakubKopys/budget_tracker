# frozen_string_literal: true

require 'users/authentication'

module AuthenticationHelper
  def auth_get(path, params: {}, headers: {}, user: nil)
    headers[:Authorization] = auth_token(user)
    get path, params: params, headers: headers
  end

  def auth_post(path, params: {}, headers: {}, user: nil)
    headers[:Authorization] = auth_token(user)
    post path, params: params, headers: headers
  end

  def auth_put(path, params: {}, headers: {}, user: nil)
    headers[:Authorization] = auth_token(user)
    put path, params: params, headers: headers
  end

  def auth_delete(path, params: {}, headers: {}, user: nil)
    headers[:Authorization] = auth_token(user)
    delete path, params: params, headers: headers
  end

  private

  def auth_token(user)
    user ||= create :user
    token = Users::Authentication.create_token user_id: user.id
    "Bearer #{token}"
  end
end
