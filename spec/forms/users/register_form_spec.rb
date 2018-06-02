# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_examples/application_form'
require 'support/shared_examples/users/basic_form'

RSpec.describe Users::RegisterForm, type: :model do
  it_behaves_like 'application_form'
  it_behaves_like 'basic_form'

  describe 'validations' do
    it { is_expected. to validate_presence_of :email }
    it { is_expected. to validate_presence_of :first_name }
    it { is_expected. to validate_presence_of :last_name }
    it { is_expected. to validate_presence_of :password }
  end
end
