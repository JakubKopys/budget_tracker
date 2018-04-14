# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:inmates).dependent :destroy }
    it { is_expected.to have_many(:households).through :inmates }

    it do
      is_expected.to have_many(:admin_inmates).class_name('Inmate').inverse_of :user
    end

    it do
      is_expected.to have_many(:administrated_households)
        .through(:admin_inmates)
        .source :household
    end
  end

  describe 'secure password' do
    it { is_expected.to have_secure_password }
  end
end
