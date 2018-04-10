# frozen_string_literal: true

if %w[development test].include? Rails.env
  task(:default).clear.enhance(['db:environment:set', 'spec', 'rubocop'])
end
