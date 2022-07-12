# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module FriendlySignup
    module NeedsHeaderSnippets
      extend ActiveSupport::Concern

      included do
        helper_method :snippets
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
    end
  end
end
