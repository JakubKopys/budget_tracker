# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_examples/application_form'
require 'support/shared_examples/households/basic_form'

RSpec.describe Households::UpdateForm, type: :model do
  it_behaves_like 'application_form'
  it_behaves_like 'basic_form'
end
