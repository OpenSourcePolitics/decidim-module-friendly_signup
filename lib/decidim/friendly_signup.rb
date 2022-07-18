# frozen_string_literal: true

require "decidim/friendly_signup/version"
require "decidim/friendly_signup/engine"

module Decidim
  module FriendlySignup
    include ActiveSupport::Configurable

    autoload :UserAttributeValidator, "decidim/friendly_signup/user_attribute_validator"

    # Whether to override passwords boxes or not
    config_accessor :override_passwords do
      true
    end

    # Whether to use instant validation or not
    config_accessor :use_instant_validation do
      true
    end

    # Whether to hide nickname and generate it automatically
    config_accessor :hide_nickname do
      true
    end

    # Use confirmation codes instead of confirmation links
    config_accessor :use_confirmation_codes do
      true
    end
  end
end

# Engines to handle logic unrelated to participatory spaces or components
Decidim.register_global_engine(
  :decidim_friendly_signup, # this is the name of the global method to access engine routes
  ::Decidim::FriendlySignup::Engine,
  at: "/friendly_signup"
)
