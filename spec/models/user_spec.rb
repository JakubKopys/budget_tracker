# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:household_users).dependent :destroy }
    it { is_expected.to have_many(:households).through :household_users }
    it { is_expected.to have_many(:invites).inverse_of :invitee }
    it { is_expected.to have_many(:requests).inverse_of :invitee }

    it do
      is_expected.to have_many(:admin_household_users)
        .class_name('HouseholdUser')
        .inverse_of :user
    end
    it do
      is_expected.to have_many(:administrated_households)
        .through(:admin_household_users)
        .source :household
    end
  end

  describe 'secure password' do
    it { is_expected.to have_secure_password }
  end
end
