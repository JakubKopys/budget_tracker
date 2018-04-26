# frozen_string_literal: true

require 'rails_helper'
require 'support/helpers/authentication_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  let(:user) { create :user }

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates user and returns user_id with token' do
        user_params = attributes_for :user

        post '/api/v1/users', params: { user: user_params }

        json_response = JSON.parse response.body
        expect(response).to be_created
        expect(json_response).to have_key 'user_id'
        expect(json_response).to have_key 'token'
      end
    end

    context 'with invalid params' do
      it 'is unrocessable and sets error messages' do
        invalid_params = { first_name: '', password: '' }

        post '/api/v1/users', params: { user: invalid_params }

        json_response = JSON.parse response.body
        expect(response).to be_unprocessable
        expect(json_response).to have_key 'errors'
      end
    end
  end

  describe 'PUT #update' do
    context 'when user is not logged in' do
      it 'is unauthorized and returns error message' do
        update_params = { last_name: 'Foo' }
        put "/api/v1/users/#{user.id}", params: { user: update_params }

        json_response = JSON.parse response.body
        expect(response).to be_unauthorized
        expect(json_response).to have_key 'errors'
      end
    end

    context 'when user is logged in but not requesting himself' do
      include AuthenticationHelper

      it 'is forbidden and returns error message' do
        other_user = create :user

        update_path = "/api/v1/users/#{other_user.id}"
        update_params = { email: FFaker::Internet.email }

        expect do
          auth_put update_path, params: { user: update_params }, user: user
        end.not_to change other_user, :email

        json_response = JSON.parse response.body
        expect(response).to be_forbidden
        expect(json_response).to have_key 'errors'
      end
    end

    context 'when user is logged in and requests himself' do
      include AuthenticationHelper

      context 'with valid params' do
        it 'updates user' do
          update_path = "/api/v1/users/#{user.id}"
          update_params = { email: FFaker::Internet.email }
          auth_put update_path, params: { user: update_params }, user: user

          expect(response).to be_success
          expect(user.reload.email).to eq update_params.fetch(:email)
        end
      end

      context 'with invalid params' do
        it 'is unprocessable and sets error messages' do
          update_path = "/api/v1/users/#{user.id}"
          invalid_params = { email: 'invalid email' }

          expect do
            auth_put update_path, params: { user: invalid_params }, user: user
          end.not_to change user, :email

          json_response = JSON.parse response.body
          expect(response).to be_unprocessable
          expect(json_response).to have_key 'errors'
        end
      end
    end
  end

  describe 'GET #invites' do
    context 'when user is not logged in' do
      it 'is unauthorized and returns errors' do
        get '/api/v1/users/invites'

        json_response = JSON.parse response.body
        expect(response).to be_unauthorized
        expect(json_response).to have_key 'errors'
      end
    end

    context 'when user is logged in' do
      include AuthenticationHelper

      it "returns current user's invites" do
        user      = create :user
        household = create :household
        invite    = create :pending_invite, invitee: user, household: household

        auth_get '/api/v1/users/invites', user: user

        expected_json_response = [
          {
            id: invite.id,
            expires_at: invite.expires_at,
            household: {
              id: household.id,
              name: household.name
            },
            invitee: {
              id: user.id,
              first_name: user.first_name,
              last_name: user.last_name,
              email: user.email
            }
          }
        ].as_json

        json_response = JSON.parse response.body
        expect(response).to be_success
        expect(json_response).to eq expected_json_response
      end
    end
  end
end
