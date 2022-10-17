# frozen_string_literal: true

module Decidim
  module FriendlySignup
    class ValidatorController < ApplicationController
      include Decidim::FormFactory

      def validate
        @form = form(Decidim::RegistrationForm).from_params(params)
        @form.errors.add(:password, :password_blank) if params[:attribute] == "password" && @form.password.blank?
        validator = UserAttributeValidator.new(form: @form, attribute: params[:attribute])
        render json: {
          valid: validator.valid?,
          error: validator.error
        }
      end
    end
  end
end
