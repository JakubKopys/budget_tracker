# frozen_string_literal: true

RSpec.shared_examples 'basic_form' do
  describe 'validations' do
    it do
      min_length = Household::MINIMUM_NAME_LENGTH
      is_expected.to validate_length_of(:name).is_at_least min_length
    end
  end
end
