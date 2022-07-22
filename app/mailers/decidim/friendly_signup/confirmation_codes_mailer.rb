# frozen_string_literal: true

module Decidim
  module FriendlySignup
    class ConfirmationCodesMailer < ApplicationMailer
      include Decidim::LocalisedMailer

      def confirmation_instructions(user, opts)
        @user = user
        @email = opts[:to] || user.email
        @token = opts[:token]
        @organization = user.organization
        @code = FriendlySignup.confirmation_code(@token)
        @expires_at = @user.confirmation_sent_at + @user.class.confirm_within if @user.class.confirm_within

        with_user(user) do
          mail(to: "#{user.name} <#{@email}>", subject: I18n.t("decidim.friendly_signup.confirmation_codes.mailer.subject", organization: @organization.name))
        end
      end
    end
  end
end
