# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HouseholdUser, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user).inverse_of :household_users }
    it { is_expected.to belong_to(:household).inverse_of :household_users }
  end
end
