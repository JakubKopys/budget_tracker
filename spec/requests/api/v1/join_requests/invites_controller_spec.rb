# frozen_string_literal: true

require 'rails_helper'
require 'support/helpers/authentication_helper'

RSpec.describe Api::V1::JoinRequests::InvitesController, type: :request do
  describe 'POST #create' do
    let(:household_with_admin) { create :household_with_admin }
    let(:admin) { household_with_admin.admins.first }
    let(:user) { create :user }

    context 'when user is not logged in' do
      it 'is unauthorized and returns errors' do
        invite_params = { household_id: 1, invitee_id: 1 }
        post '/api/v1/join_requests/invites', params: invite_params

        json_response = JSON.parse response.body
        expect(response).to be_unauthorized
        expect(json_response).to have_key 'errors'
      end
    end

    context 'when user is logged in but is not an admin' do
      include AuthenticationHelper

      it 'is forbidden and returns errors' do
        household = create :household

        invite_params = { household_id: household.id, user_id: user.id }
        auth_post '/api/v1/join_requests/invites', params: invite_params

        json_response = JSON.parse response.body
        expect(response).to be_forbidden
        expect(json_response).to have_key 'errors'
      end
    end

    context 'when user is logged in and is an admin' do
      include AuthenticationHelper

      context 'with valid params' do
        it 'creates invite' do
          household = household_with_admin

          invite_params = { household_id: household.id, user_id: user.id }
          invite_path = '/api/v1/join_requests/invites'

          expect do
            auth_post invite_path, params: invite_params, user: admin
          end.to change(Invite, :count).by 1

          json_response = JSON.parse response.body
          expect(response).to be_created
          expect(json_response).to have_key 'id'
        end
      end

      context 'with invalid user_id' do
        it 'is not found, does not create an invite and returns error' do
          household = household_with_admin

          invite_params = { household_id: household.id, user_id: 'foobar' }
          invite_path = '/api/v1/join_requests/invites'

          expect do
            auth_post invite_path, params: invite_params, user: admin
          end.not_to change(Invite, :count)

          json_response = JSON.parse response.body
          expect(response).to be_not_found
          expect(json_response).to have_key 'error'
        end
      end
    end
  end

  xdescribe 'PUT #update' do
    context 'when user is not logged in' do
      it 'is unauthorized and returns errors' do
        invite = create :invite

        update_params = { state: 'accepted' }
        update_path = "/api/v1/join_requests/invites/#{invite.id}"

        expect do
          put update_path, params: { invite: update_params }
        end.not_to change invite, :state

        json_response = JSON.parse response.body
        expect(response).to be_unauthorized
        expect(json_response).to have_key 'errors'
      end
    end

    context 'when user is logged in but is not an admin' do
      include AuthenticationHelper

      it 'is forbidden and returns errors' do
        invite = create :invite

        update_params = { state: 'accepted' }
        update_path = "/api/v1/join_requests/invites/#{invite.id}"

        expect do
          auth_put update_path, params: { invite: update_params }
        end.not_to change invite, :state

        json_response = JSON.parse response.body
        expect(response).to be_forbidden
        expect(json_response).to have_key 'errors'
      end
    end

    context 'when user is logged in and is an admin' do
      include AuthenticationHelper

      context 'with invalid params' do
        it 'is unprocessable and returns error' do
          household = create :household_with_admin
          admin = household.admins.first
          invite = create :invite, household: household

          update_params = { state: 'foobar' }
          update_path = "/api/v1/join_requests/invites/#{invite.id}"

          expect do
            auth_put update_path, params: { invite: update_params }, user: admin
          end.not_to change invite, :state

          json_response = JSON.parse response.body
          expect(response).to be_unprocessable
          expect(json_response).to have_key 'errors'
        end
      end

      context 'with valid params' do
        it 'is success and updates invite state' do
          household = create :household_with_admin
          admin = household.admins.first
          invite = create :invite, household: household

          update_params = { state: 'accepted' }
          update_path = "/api/v1/join_requests/invites/#{invite.id}"

          expect do
            auth_put update_path, params: { invite: update_params }, user: admin
          end.to change(invite, :state).to update_params.fetch('state')

          expect(response).to be_success
        end
      end
    end
  end

  # TODO: write tests
  xdescribe 'DELETE #destroy' do
  end
end
