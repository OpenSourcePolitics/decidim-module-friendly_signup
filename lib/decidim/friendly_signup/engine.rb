# frozen_string_literal: true

require "rails"
require "decidim/core"
require "rack/attack"

module Decidim
  module FriendlySignup
    # This is the engine that runs on the public interface of friendly_signup.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::FriendlySignup

      routes do
        devise_scope :user do
          resources :confirmation_codes, only: [:index, :create]
        end
        post :validate, to: "validator#validate"
      end

      # Prepare a zone to create overrides
      # https://edgeguides.rubyonrails.org/engines.html#overriding-models-and-controllers
      # overrides
      config.to_prepare do
        Decidim::Devise::RegistrationsController.include(Decidim::FriendlySignup::NeedsHeaderSnippets)
        Decidim::Devise::RegistrationsController.include(Decidim::FriendlySignup::RegistrationsRedirect)
        Decidim::Devise::ConfirmationsController.include(Decidim::FriendlySignup::RegistrationsRedirect)
        Decidim::Devise::InvitationsController.include(Decidim::FriendlySignup::NeedsHeaderSnippets)
        Decidim::Devise::PasswordsController.include(Decidim::FriendlySignup::NeedsHeaderSnippets)
        Decidim::AccountController.include(Decidim::FriendlySignup::NeedsHeaderSnippets)
        Decidim::RegistrationForm.include(Decidim::FriendlySignup::AutoNickname)
        Decidim::User.include(Decidim::FriendlySignup::NeedsRegistrationCodes)
      end

      initializer "FriendlySignup.confirmation_throttling" do |_app|
        # Throttle confirmation attempts for a given code parameter to 6 reqs/minute
        # Return the confirmation_token as a discriminator on POST /users/sign_in requests
        Rack::Attack.throttle("limit confirmations attempts per code", limit: 5, period: 60.seconds) do |request|
          request.params["confirmation_token"] if request.path == "/friendly_signup/confirmation_codes" && request.post?
        end
      end

      initializer "FriendlySignup.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end
    end
  end
end
