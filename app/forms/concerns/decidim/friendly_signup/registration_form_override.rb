# frozen_string_literal: true

module Decidim
  module FriendlySignup
    class RegistrationFormOverride < Decidim::RegistrationForm
      validate :no_special_characters_in_email

      private

      EMAIL_REGEX = /\A[^<>"']+@[a-zA-Z0-9\-.]+\.[a-zA-Z]{2,}/
      def no_special_characters_in_email
        errors.add(:email, :invalid) if email =~ EMAIL_REGEX
      end
    end
  end
end
