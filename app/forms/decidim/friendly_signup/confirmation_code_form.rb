# frozen_string_literal: true

module Decidim
  module FriendlySignup
    class ConfirmationCodeForm < Decidim::Form
      attribute :confirmation_code
      attribute :code
    end
  end
end
