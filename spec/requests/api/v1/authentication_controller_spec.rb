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
end
