# frozen_string_literal: true

RSpec.shared_examples 'basic_form' do
  describe 'validations' do
    it { is_expected.to allow_value('user@email.valid').for :email }
    it { is_expected.not_to allow_value('invalidemail').for :email }

    it do
      min_length = User::MINIMUM_PASSWORD_LENGTH
      is_expected.to validate_length_of(:password).is_at_least min_length
    end

    it 'validates uniqueness of email' do
      user = create :user
      form = described_class.new(email: user.email)

      expect(form.valid?).to be false
      errors = form.errors.details[:email]
      expect(errors.first[:error]).to eq 'is taken'
    end
  end
end
