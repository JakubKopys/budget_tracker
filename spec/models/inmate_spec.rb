# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Inmate, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user).inverse_of :inmates }
    it { is_expected.to belong_to(:household).inverse_of :inmates }
  end
end
