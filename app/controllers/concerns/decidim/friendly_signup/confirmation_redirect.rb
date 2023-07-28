# frozen_string_literal: true

module Decidim
  module FriendlySignup
    module ConfirmationRedirect
      def redirect_url
        if warden_message == :unconfirmed
          decidim_friendly_signup.confirmation_codes_path(confirmation_token: Decidim::User.find_by(email: params[:user][:email]).confirmation_token)
        else
          super
        end
      end
    end
  end
end
