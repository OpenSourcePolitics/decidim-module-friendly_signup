# frozen_string_literal: true

module Decidim
  module FriendlySignup
    class ConfirmationCodesMailer < ApplicationMailer
      helper_method :confirm_path_url
      include Decidim::LocalisedMailer

      def confirmation_instructions(user, opts)
        @user = user
        @email = opts[:to] || user.email
        @token = opts[:token]
        @organization = user.organization
        @code = FriendlySignup.confirmation_code(@token)
        @expires_at = @user.confirmation_sent_at + @user.class.confirm_within if @user.class.confirm_within

        with_user(user) do
          mail(to: "#{user.name} <#{@email}>", subject: I18n.t("decidim.friendly_signup.confirmation_codes.mailer.subject", organization: @organization.name, code: @code))
        end
      end

      private

      def confirm_path_url
        "#{root_url}#{decidim_friendly_signup.confirmation_codes_path(confirmation_token: @token)}"
      end

      def root_url
        @root_url ||= decidim.root_url(host: @user.organization.host)[0..-2]
      end
    end
  end
end
