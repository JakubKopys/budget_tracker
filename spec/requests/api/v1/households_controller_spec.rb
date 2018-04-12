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
          auth_post '/api/v1/households', params: { household: household_params }

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
        it 'is unauthorized and returns errors' do
          household = create :household

          update_params = { name: 'New Name' }
          update_path = "/api/v1/households/#{household.id}"
          auth_put update_path, params: { household: update_params }

          json_response = JSON.parse response.body
          expect(response).to be_unauthorized
          expect(json_response).to have_key 'errors'
        end
      end

      context 'when is an admin' do
        let(:user) { create :user }
        let(:household) { create :household }

        before { create :inmate, user: user, household: household, is_admin: true }

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
end
