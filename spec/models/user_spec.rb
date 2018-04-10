# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:inmates).dependent :destroy }
    it { is_expected.to have_many(:households).through :inmates }
  end

  describe 'secure password' do
    it { is_expected.to have_secure_password }
  end
end
