# frozen_string_literal: true

require 'simplecov'
SimpleCov.start 'rails' do
  add_filter %w[spec vendor mailers channels jobs]

  add_group 'Forms', 'app/forms'
  add_group 'Interactors', 'app/interactors'
  add_group 'Serializers', 'app/serializers'
  add_group 'Libraries', 'lib'
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.filter_run_when_matching :focus

  config.example_status_persistence_file_path = 'tmp/rspec-cache.txt'

  config.disable_monkey_patching!

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.profile_examples = 10

  config.order = :random
end
