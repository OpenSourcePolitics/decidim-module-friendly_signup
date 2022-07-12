# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module FriendlySignup
    module NeedsHeaderSnippets
      extend ActiveSupport::Concern

      included do
        helper_method :snippets, :friendly_override_activated?
      end

      def snippets
        @snippets ||= Decidim::Snippets.new

        unless @snippets.any?(:friendly_signup_snippets)
          @snippets.add(:friendly_signup_snippets, ActionController::Base.helpers.javascript_pack_tag("decidim_friendly_signup"))
          @snippets.add(:friendly_signup_snippets, ActionController::Base.helpers.stylesheet_pack_tag("decidim_friendly_signup"))
          @snippets.add(:head, @snippets.for(:friendly_signup_snippets))
        end

        @snippets
      end

      def friendly_override_activated?(type)
        case type
        when :override_passwords
          Decidim::FriendlySignup.override_passwords.present?
        end
      end
    end
  end
end
