# frozen_string_literal: true

class Inmate < ApplicationRecord
  belongs_to :user, inverse_of: :inmates
  belongs_to :household, inverse_of: :inmates
end
