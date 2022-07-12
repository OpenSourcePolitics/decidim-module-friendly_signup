# frozen_string_literal: true

require "decidim/friendly_signup/engine"

module Decidim
  # This namespace holds the logic of the `FriendlySignup` component. This component
  # allows users to create friendly_signup in a participatory space.
  module FriendlySignup
    include ActiveSupport::Configurable

    # Whether to override passwords boxes or not
    config_accessor :override_passwords do
      true
    end
  end
end
