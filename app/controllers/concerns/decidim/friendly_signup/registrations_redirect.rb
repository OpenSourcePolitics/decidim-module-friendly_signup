# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module FriendlySignup
    module RegistrationsRedirect
      extend ActiveSupport::Concern

      included do
        def show
          if Decidim::FriendlySignup.use_confirmation_codes.present?
            respond_with_navigational(resource) { redirect_to decidim.new_user_confirmation_path }
            return
          end

          super
        end

        def after_sign_up_path_for(user)
          codes_confirmation_path(user) || super(user)
        end

        def after_inactive_sign_up_path_for(user)
          codes_confirmation_path(user) || super(user)
        end

        def after_resending_confirmation_instructions_path_for(resource_name)
          user = Decidim::User.find_by email: params.dig(:user, :email)
          codes_confirmation_path(user) || super(resource_name)
        end
      end

      protected

      # since https://github.com/decidim/decidim/pull/9932
      # it is required to override this method
      def devise_mapping
        ::Devise.mappings[:user]
      end

      private

      def codes_confirmation_path(user)
        return if Decidim::FriendlySignup.use_confirmation_codes.blank?
        return if user.blank?
        return unless user.inactive_message.to_s == "unconfirmed"

        set_flash_message! :notice, :signed_up_but_code_required
        decidim_friendly_signup.confirmation_codes_path(confirmation_token: user.confirmation_token)
      end
    end
  end
end
