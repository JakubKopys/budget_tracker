# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Household, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:inmates).dependent :destroy }
    it { is_expected.to have_many(:users).through :inmates }

    it do
      is_expected.to have_many(:admin_inmates).class_name('Inmate').inverse_of :household
    end

    it do
      is_expected.to have_many(:admins).through(:admin_inmates).source :user
    end
  end
end
