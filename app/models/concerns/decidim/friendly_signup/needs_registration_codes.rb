# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module FriendlySignup
    module NeedsRegistrationCodes
      extend ActiveSupport::Concern

      included do
        def send_confirmation_instructions
          return super if Decidim::FriendlySignup.use_confirmation_codes.blank?
          return super unless inactive_message.to_s == "unconfirmed"

          generate_confirmation_token! unless @raw_confirmation_token

          opts = pending_reconfirmation? ? { to: unconfirmed_email } : {}
          opts[:token] = @raw_confirmation_token
          ConfirmationCodesMailer.confirmation_instructions(self, opts).deliver_now
        end
      end
    end
  end
end
