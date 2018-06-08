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
        household = create :household

        invite_params = { invitee_id: 1 }
        post "/api/v1/households/#{household.id}/join_requests/invites",
             params: invite_params

        json_response = JSON.parse response.body
        expect(response).to be_unauthorized
        expect(json_response).to have_key 'errors'
      end
    end

    context 'when user is logged in but is not an admin' do
      include AuthenticationHelper

      it 'is forbidden and returns errors' do
        household = create :household

        invite_params = { user_id: user.id }
        expect do
          auth_post "/api/v1/households/#{household.id}/join_requests/invites",
                    params: invite_params
        end.not_to change Invite, :count

        json_response = JSON.parse response.body
        expect(response).to be_not_found
        expect(json_response).to have_key 'errors'
      end
    end

    context 'when user is logged in and is an admin' do
      include AuthenticationHelper

      context 'with valid params' do
        it 'creates invite' do
          household = household_with_admin

          invite_params = { user_id: user.id }
          invite_path = "/api/v1/households/#{household.id}/join_requests/invites"

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

          invite_params = { user_id: 'foobar' }
          invite_path = "/api/v1/households/#{household.id}/join_requests/invites"

          expect do
            auth_post invite_path, params: invite_params, user: admin
          end.not_to change(Invite, :count)

          json_response = JSON.parse response.body
          expect(response).to be_not_found
          expect(json_response).to have_key 'errors'
        end
      end
    end
  end

  describe 'POST #accept' do
    context 'when user is not logged in' do
      it 'is unauthorized and returns errors' do
        household = create :household
        invite = create :invite, household: household

        path = "/api/v1/households/#{household.id}/join_requests/invites/#{invite.id}" \
               '/accept'

        expect { post path }.not_to(change { invite.reload.state })

        json_response = JSON.parse response.body
        expect(response).to be_unauthorized
        expect(json_response).to have_key 'errors'
      end
    end

    context 'when user is logged in' do
      include AuthenticationHelper

      it 'is success and updates invite state' do
        user      = create :user
        household = create :household
        invite    = create :invite, household: household, invitee: user

        path = "/api/v1/households/#{household.id}/join_requests/invites/#{invite.id}" \
               '/accept'

        expect do
          auth_post path, user: user
          invite.reload
          household.reload
        end.to  change(invite, :state).to('accepted')
           .and change(household.users, :count).by 1

        expect(response).to be_success
      end
    end
  end

  describe 'POST #decline' do
    context 'when user is not logged in' do
      it 'is unauthorized and returns errors' do
        household = create :household
        invite = create :invite, household: household

        path = "/api/v1/households/#{household.id}/join_requests/invites/#{invite.id}" \
               '/decline'

        expect { post path }.not_to(change { invite.reload.state })

        json_response = JSON.parse response.body
        expect(response).to be_unauthorized
        expect(json_response).to have_key 'errors'
      end
    end

    context 'when user is logged in but is not an admin' do
      include AuthenticationHelper

      it 'is success and updates invite state' do
        user      = create :user
        household = create :household
        invite    = create :invite, household: household, invitee: user

        path = "/api/v1/households/#{household.id}/join_requests/invites/#{invite.id}" \
               '/decline'

        expect do
          auth_post path, user: user
          invite.reload
          household.reload
        end.to  change(invite, :state).to('declined')
           .and not_change(household.users, :count)

        expect(response).to be_success
      end
    end
  end
end
