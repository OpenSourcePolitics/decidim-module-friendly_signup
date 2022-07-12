# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module FriendlySignup
    # This is the engine that runs on the public interface of friendly_signup.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::FriendlySignup

      # Prepare a zone to create overrides
      # https://edgeguides.rubyonrails.org/engines.html#overriding-models-and-controllers
      # overrides
      config.after_initialize do
        Decidim::Devise::RegistrationsController.include(Decidim::FriendlySignup::NeedsHeaderSnippets)
        Decidim::Devise::InvitationsController.include(Decidim::FriendlySignup::NeedsHeaderSnippets)
        Decidim::AccountController.include(Decidim::FriendlySignup::NeedsHeaderSnippets)
      end

      routes do
        # Add engine routes here
        # resources :friendly_signup
        # root to: "friendly_signup#index"
      end

      initializer "FriendlySignup.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end
    end
  end
end
