# frozen_string_literal: true

class Inmate < ApplicationRecord
  belongs_to :user
  belongs_to :household
end
