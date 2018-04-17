# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Household, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:household_users).dependent :destroy }
    it { is_expected.to have_many(:users).through :household_users }
    it { is_expected.to have_many :invites }
    it { is_expected.to have_many :requests }

    it do
      is_expected.to have_many(:admin_household_users)
        .class_name('HouseholdUser')
        .inverse_of :household
    end
    it do
      is_expected.to have_many(:admins).through(:admin_household_users).source :user
    end
  end
end
