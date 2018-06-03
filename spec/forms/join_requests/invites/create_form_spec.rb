# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_examples/application_form'

RSpec.describe JoinRequests::Invites::CreateForm, type: :model do
  it_behaves_like 'application_form'

  describe 'validations' do
    it { is_expected.to validate_presence_of :user }
    it { is_expected.to validate_presence_of :household }

    it 'validates household residents exclusion' do
      user = create :user
      household = create :household
      household.users << user

      form = described_class.new(user: user, household: household)

      expect(form.valid?).to be false
      errors = form.errors.details[:user]
      expect(errors.first[:error]).to eq 'is already an household resident'
    end
  end
end
