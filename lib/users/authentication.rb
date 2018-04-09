# frozen_string_literal: true

module Users
  module Authentication
    extend self
    class Error < ::StandardError; end

    ALGORITHM = 'HS512'
    HEADER_REGEXP = /\ABearer\s{1}.*\z/

    def create_token(user_id:)
      payload = { user_id: user_id }
      encode payload
    end

    def authenticate(header:)
      ensure_header_format header
      token = token_from_header header
      payload = decode token
      raise Error, 'token expired' if ExpiredToken.where(token: token).exists?

      User.find(payload['user_id'])
    rescue JWT::ExpiredSignature
      raise Error, 'token expired'
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      raise Error, 'could not authorize token'
    end

    def token_from_header(header)
      header.split('Bearer ').last
    end

    private

    def encode(payload)
      in_one_day = Time.current + 1.day
      expirable_payload = payload.merge exp: in_one_day.to_i

      JWT.encode expirable_payload, jwt_secret, ALGORITHM
    end

    def decode(token)
      JWT.decode(token, jwt_secret, true, algorithm: ALGORITHM).first
    end

    def jwt_secret
      Rails.application.secrets.secret_key_base
    end

    def ensure_header_format(header)
      return if header&.match?(HEADER_REGEXP)

      raise Error, 'Authentication header has to have format: Bearer my.personal.token'
    end
  end
end
