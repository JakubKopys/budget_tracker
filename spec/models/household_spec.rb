# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Household, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:inmates).dependent :destroy }
    it { is_expected.to have_many(:users).through :inmates }
  end
end
