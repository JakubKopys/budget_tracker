# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Request, type: :model do
  it { is_expected.to belong_to :household }
  it { is_expected.to belong_to(:invitee).class_name('User').inverse_of :requests }
end
