# frozen_string_literal: true

module Users
  class RegisterForm < BasicForm
    validates :email, :first_name, :last_name, :password, presence: true

    ATTRIBUTES = BASE_ATTRIBUTES

    attr_accessor(*ATTRIBUTES)
  end
end

