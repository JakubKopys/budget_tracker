# frozen_string_literal: true

require 'rails_helper'
require 'support/helpers/authentication_helper'

RSpec.describe Api::V1::JoinRequests::RequestsController, type: :request do
  describe 'POST #create' do
    context 'when user is not logged in' do
      it 'is unautorized and returns errors' do
        household = create :household

        post "/api/v1/households/#{household.id}/join_requests/requests"

        json_response = JSON.parse response.body
        expect(response).to be_unauthorized
        expect(json_response).to have_key 'errors'
      end
    end

    context 'when user is logged in' do
      include AuthenticationHelper

      it 'creates request' do
        household = create :household

        expect do
          auth_post "/api/v1/households/#{household.id}/join_requests/requests"
        end.to change(Request, :count).by 1

        json_response = JSON.parse response.body
        expect(response).to be_created
        expect(json_response).to have_key 'id'
      end

      context 'when user is already invited' do
        it 'is unprocessable and returns errors' do
          household = create :household
          user = create :user
          create :pending_invite, invitee: user, household: household

          expect do
            auth_post "/api/v1/households/#{household.id}/join_requests/requests",
                      user: user
          end.not_to change(Request, :count)

          json_response = JSON.parse response.body
          expect(response).to be_unprocessable
          expect(json_response).to have_key 'errors'
        end
      end
    end
  end
end
