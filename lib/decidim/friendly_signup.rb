# frozen_string_literal: true

require "decidim/friendly_signup/engine"

module Decidim
  module FriendlySignup
    include ActiveSupport::Configurable

    # Whether to override passwords boxes or not
    config_accessor :override_passwords do
      true
    end
  end
end
