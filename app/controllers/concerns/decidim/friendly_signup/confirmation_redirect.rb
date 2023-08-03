# frozen_string_literal: true

module Decidim
  module FriendlySignup
    module ConfirmationRedirect
      extend ActiveSupport::Concern

      included do
        def redirect_url
          case warden_message
          when :unconfirmed

            return scope_url unless params[:user]

            user = User.find_by(email: params[:user][:email])

            return scope_url if user.nil?

            return decidim_friendly_signup.confirmation_codes_path(confirmation_token: user.confirmation_token) unless user.confirmed?

            scope_url
          when :timeout
            flash[:timedout] = true if is_flashing_format?

            path = if request.get?
                     attempted_path
                   else
                     request.referer
                   end

            path || scope_url
          else
            scope_url
          end
        end
      end
    end
  end
end
