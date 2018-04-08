module Users
  class UpdateForm < BasicForm
    ADDITIONAL_ATTRIBUTES = %i(password_confirmation).freeze

    ATTRIBUTES = (BASE_ATTRIBUTES + ADDITIONAL_ATTRIBUTES).freeze

    attr_accessor(*ATTRIBUTES)
  end
end

