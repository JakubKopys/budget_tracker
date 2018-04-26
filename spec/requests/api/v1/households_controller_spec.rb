# frozen_string_literal: true

require 'rails_helper'
require 'support/helpers/authentication_helper'

RSpec.describe Api::V1::HouseholdsController, type: :request do
  describe 'POST #create' do
    context 'when user is not logged in' do
      it 'is unauthorized and returns errors' do
        household_params = attributes_for :household
        post '/api/v1/households', params: { household: household_params }

        json_response = JSON.parse response.body
        expect(response).to be_unauthorized
        expect(json_response).to have_key 'errors'
      end
    end

    context 'when user is logged in' do
      include AuthenticationHelper

      context 'with valid params' do
        it 'is created and creates household' do
          household_params = attributes_for :household

          expect do
            auth_post '/api/v1/households', params: { household: household_params }
          end.to change(Household, :count).by 1

          json_response = JSON.parse response.body
          expect(response).to be_created
          expect(json_response).to have_key 'household'
        end

        context 'with invalid params' do
          it 'is unprocessable and returns errors' do
            invalid_params = { name: '' }
            auth_post '/api/v1/households', params: { household: invalid_params }

            json_response = JSON.parse response.body
            expect(response).to be_unprocessable
            expect(json_response).to have_key 'errors'
          end
        end
      end
    end
  end

  describe 'PUT #update' do
    context 'when user is not logged in' do
      it 'is unauthorized and returns errors' do
        household = create :household

        update_params = { name: 'New Name' }
        put "/api/v1/households/#{household.id}", params: { household: update_params }

        json_response = JSON.parse response.body
        expect(response).to be_unauthorized
        expect(json_response).to have_key 'errors'
      end
    end

    context 'when user is logged in' do
      include AuthenticationHelper

      context 'when is not an admin' do
        it 'is forbidden and returns errors' do
          household = create :household

          update_params = { name: 'New Name' }
          update_path = "/api/v1/households/#{household.id}"
          auth_put update_path, params: { household: update_params }

          json_response = JSON.parse response.body
          expect(response).to be_forbidden
          expect(json_response).to have_key 'errors'
        end
      end

      context 'when is an admin' do
        let(:household) { create :household_with_admin }
        let(:user) { household.admins.first! }

        context 'with valid params' do
          it 'updates user and returns household' do
            update_params = { name: 'New Name' }
            update_path = "/api/v1/households/#{household.id}"
            auth_put update_path, params: { household: update_params }, user: user

            expected_json_response = {
              id: household.id,
              name: update_params.fetch(:name)
            }.as_json

            json_response = JSON.parse response.body
            expect(response).to be_success
            expect(json_response).to eq expected_json_response
            expect(household.reload.name).to eq update_params.fetch(:name)
          end
        end

        context 'with invalid params' do
          it 'is unprocessable and returns errors' do
            invalid_params = { name: '' }
            update_path = "/api/v1/households/#{household.id}"
            auth_put update_path, params: { household: invalid_params }, user: user

            json_response = JSON.parse response.body
            expect(response).to be_unprocessable
            expect(json_response).to have_key 'errors'
          end
        end
      end
    end
  end

  describe 'GET #invites' do
    context 'when user is not logged in' do
      it 'is unauthorized and returns errors' do
        household = create :household

        get "/api/v1/households/#{household.id}/invites"

        json_response = JSON.parse response.body
        expect(response).to be_unauthorized
        expect(json_response).to have_key 'errors'
      end
    end

    context 'when user is logged in but is not an admin' do
      include AuthenticationHelper

      it 'is not found and returns errors' do
        household = create :household

        auth_get "/api/v1/households/#{household.id}/invites"

        json_response = JSON.parse response.body
        expect(response).to be_not_found
        expect(json_response).to have_key 'errors'
      end
    end

    context 'when user is logged in and is an household admin' do
      include AuthenticationHelper

      it 'returns pending invites' do
        household = create :household_with_admin
        invitee   = create :user
        invite    = create :invite, household: household, invitee: invitee
        admin     = household.admins.first

        params = { page: 1, per_page: 10 }
        auth_get "/api/v1/households/#{household.id}/invites",
                 user: admin,
                 params: params

        expected_json_response = [
          {
            id: invite.id,
            expires_at: invite.expires_at,
            household: {
              id: household.id,
              name: household.name
            },
            invitee: {
              id: invitee.id,
              first_name: invitee.first_name,
              last_name: invitee.last_name,
              email: invitee.email
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
