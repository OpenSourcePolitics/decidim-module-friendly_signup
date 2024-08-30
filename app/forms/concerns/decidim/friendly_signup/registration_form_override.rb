module Decidim
  module FriendlySignup
    class RegistrationFormOverride < Decidim::RegistrationForm
      validate :no_special_characters_in_email

      private

      def no_special_characters_in_email
        if email =~ /[<>'"]/
          errors.add(:email, "contains invalid characters")
        end
      end
    end
  end
end
