# frozen_string_literal: true

module Decidim
  module FriendlySignup
    class ConfirmationCodesMailer < ApplicationMailer
      include Decidim::LocalisedMailer

      def confirmation_instructions(user, token)
        @user = user
        @organization = user.organization
        @token = token

        with_user(user) do
          mail(to: "#{user.name} <#{user.email}>", subject: I18n.t("decidim.friendly_signup.confirmation_codes.mailer.subject", organization: @organization.name))
        end
      end
    end
  end
end
