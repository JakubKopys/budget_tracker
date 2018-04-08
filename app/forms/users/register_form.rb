module Users
  class RegisterForm < BasicForm
    validates :email, :first_name, :last_name, :password, presence: true
    validates :email, format: { with: EMAIL_REGEXP }

    ATTRIBUTES = BASE_ATTRIBUTES

    attr_accessor(*ATTRIBUTES)
  end
end

