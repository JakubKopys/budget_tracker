# frozen_string_literal: true

module Users
  class Update < ApplicationInteractor
    def call
      user = User.find context.id
      validate_form user
      update_user user

      context.result = ProfileSerializer.new(user).as_json
    end

    private

    def form_params
      UpdateForm::ATTRIBUTES.each_with_object({}) do |form_attribute, hash|
        hash[form_attribute] = context.public_send(form_attribute)
      end
    end

    def validate_form(user)
      form = UpdateForm.new form_params
      stop form.errors, :unprocessable_entity unless form.validate
    end

    def permitted_params
      form_params.except :password_confirmation
    end

    def update_user(user)
      user.update! permitted_params.compact
    end
  end
end
