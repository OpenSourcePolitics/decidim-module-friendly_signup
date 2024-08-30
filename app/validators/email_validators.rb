module Decidim
  module FriendlySignup
    class EmailValidator < ActiveModel::EachValidator
      CUSTOM_EMAIL_REGEX = /\A[^<>"']+@[a-zA-Z0-9\-.]+\.[a-zA-Z]{2,}/

      def validate_each(record, attribute, value)
        unless value =~ CUSTOM_EMAIL_REGEX
          record.errors.add(attribute, :invalid_format, message: I18n.t("errors.messages.email.invalid_format"))
        end
      end
    end
  end
end
