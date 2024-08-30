# frozen_string_literal: true

module Decidim
  module FriendlySignup
    class RegistrationFormOverride < Decidim::RegistrationForm
      validate :no_special_characters_in_email

      private

      def no_special_characters_in_email
        errors.add(:email, :invalid) if email =~ /[<>'"]/
      end
    end
  end
end
