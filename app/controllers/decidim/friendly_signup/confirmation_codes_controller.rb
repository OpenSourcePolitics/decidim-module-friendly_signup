# frozen_string_literal: true

module Decidim
  module FriendlySignup
    class ConfirmationCodesController < Decidim::Devise::ConfirmationsController
      include Decidim::FormFactory

      def index
        @form = form(ConfirmationCodeForm).from_params(params)
      end

      def create
        @form = form(ConfirmationCodeForm).from_params(params)
        byebug
      end
    end
  end
end
