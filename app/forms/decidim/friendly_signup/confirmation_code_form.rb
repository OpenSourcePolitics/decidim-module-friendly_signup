# frozen_string_literal: true

module Decidim
  module FriendlySignup
    class ConfirmationCodeForm < Decidim::Form
      attribute :confirmation_token, String
      attribute :code, Integer

      validates :code, :confirmation_token, presence: true
      validate :code_matches_confirmation_token
      validate :user_exists

      private

      def code_matches_confirmation_token
        return if FriendlySignup.confirmation_code(confirmation_token) == code

        errors.add(:code, I18n.t("confirmation_code_form.invalid", scope: "decidim.friendly_signup"))
      end

      def user_exists
        return if User.exists?(confirmation_token: confirmation_token, organization: current_organization)

        errors.add(:code, I18n.t("confirmation_code_form.user_invalid", scope: "decidim.friendly_signup"))
      end
    end
  end
end
