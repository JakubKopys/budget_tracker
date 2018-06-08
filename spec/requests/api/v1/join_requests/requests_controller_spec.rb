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

  describe 'POST #accept' do
    context 'when user is not logged in' do
      it 'is unautorized and returns errors' do
        household = create :household
        request = create :request, household: household

        path = "/api/v1/households/#{household.id}/join_requests/requests/#{request.id}" \
               '/accept'

        expect { post path }.not_to(change { request.reload.state })

        json_response = JSON.parse response.body
        expect(response).to be_unauthorized
        expect(json_response).to have_key 'errors'
      end
    end

    context 'when user is logged in but is not an admin' do
      include AuthenticationHelper

      it 'is not found and returns errors' do
        user      = create :user
        household = create :household
        request   = create :request, household: household

        path = "/api/v1/households/#{household.id}/join_requests/requests/#{request.id}" \
               '/accept'

        expect { auth_post path, user: user }.not_to(change { request.reload.state })

        json_response = JSON.parse response.body
        expect(response).to be_not_found
        expect(json_response).to have_key 'errors'
      end
    end

    context 'when user is logged in and is an admin' do
      include AuthenticationHelper

      it 'is success and updates request state' do
        household = create :household_with_admin
        request   = create :request, household: household
        admin     = household.admins.first

        path = "/api/v1/households/#{household.id}/join_requests/requests/#{request.id}" \
               '/accept'

        expect do
          auth_post path, user: admin
          request.reload
          household.reload
        end.to  change(request, :state).to('accepted')
           .and change(household.users, :count).by 1

        expect(response).to be_success
      end
    end
  end

  describe 'POST #decline' do
    context 'when user is not logged in' do
      it 'is unauthorized and returns errors' do
        household = create :household
        request = create :request, household: household

        path = "/api/v1/households/#{household.id}/join_requests/requests/#{request.id}" \
               '/decline'

        expect { post path }.not_to(change { request.reload.state })

        json_response = JSON.parse response.body
        expect(response).to be_unauthorized
        expect(json_response).to have_key 'errors'
      end
    end

    context 'when user is logged in but is not an admin' do
      include AuthenticationHelper

      it 'is not found and returns error' do
        household = create :household
        request = create :request, household: household

        path = "/api/v1/households/#{household.id}/join_requests/requests/#{request.id}" \
               '/decline'

        expect { auth_post path }.not_to(change { request.reload.state })

        json_response = JSON.parse response.body
        expect(response).to be_not_found
        expect(json_response).to have_key 'errors'
      end
    end

    context 'when user is logged in and is an admin' do
      include AuthenticationHelper

      it 'is success, creates household user and updates request state' do
        household = create :household_with_admin
        request = create :request, household: household
        admin = household.admins.first

        path = "/api/v1/households/#{household.id}/join_requests/requests/#{request.id}" \
               '/decline'

        expect do
          auth_post path, user: admin
          request.reload
          household.reload
        end.to  change(request, :state).to('declined')
           .and not_change(household.users, :count)

        expect(response).to be_success
      end
    end
  end
end
