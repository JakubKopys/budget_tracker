# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Inmate, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :household }
  end
end
