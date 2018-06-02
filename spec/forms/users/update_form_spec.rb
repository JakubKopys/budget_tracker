# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_examples/application_form'
require 'support/shared_examples/users/basic_form'

RSpec.describe Users::UpdateForm, type: :model do
  it_behaves_like 'application_form'
  it_behaves_like 'application_form'

  describe 'validations' do
    it { is_expected.to allow_value(nil).for :email }
  end
end
