require 'rails_helper'
require 'support/helpers/authentication_helper'

RSpec.describe Api::V1::AuthenticationController, type: :request do
  let(:user) { create :user }

  describe 'POST #create' do
    context 'when email and password matches' do
      it 'returns user_id and token' do
        login_params = { email: user.email, password: user.password }
        post '/api/v1/users/login', params: login_params

        json_response = JSON.parse(response.body)
        expect(response).to be_success
        expect(json_response.fetch('user_id')).to eq user.id
        expect(json_response).to have_key 'token'
      end
    end

    context 'when email does not exist' do
      it 'is not found' do
        login_params = { email: 'does@not.exist', password: 'supersecret' }
        post '/api/v1/users/login', params: login_params

        json_response = JSON.parse(response.body)
        expect(response).to be_not_found
        expect(json_response).to have_key 'errors'
      end
    end

    context 'when email and password does not match' do
      it 'is not found' do
        login_params = { email: user.email, password: 'foobar' }
        post '/api/v1/users/login', params: login_params

        json_response = JSON.parse(response.body)
        expect(response).to be_not_found
        expect(json_response).to have_key 'errors'
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is not logged in' do
      it 'is unauthorized and returns error message' do
        delete '/api/v1/users/logout'

        json_response = JSON.parse(response.body)
        expect(response).to be_unauthorized
        expect(json_response).to have_key 'errors'
      end
    end

    context 'when user is logged in' do
      include AuthenticationHelper

      it 'expires token so next requests with this token are unauthrized' do
        auth_delete '/api/v1/users/logout', user: user

        expect(response).to be_no_content

        auth_delete '/api/v1/users/logout', user: user

        expect(response).to be_unauthorized
      end
    end
  end
end
