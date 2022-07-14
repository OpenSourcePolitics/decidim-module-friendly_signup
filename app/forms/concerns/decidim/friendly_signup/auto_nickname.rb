# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module FriendlySignup
    module AutoNickname
      extend ActiveSupport::Concern

      included do
        def nickname
          return super unless FriendlySignup.hide_nickname

          UserBaseEntity.nicknamize(name || email, organization: current_organization)
        end

        private

        # nickname is removed from the view, so put any (that shouldn't ever happen) error on the base
        def nickname_unique_in_organization
          return false unless nickname

          errors.add :base, :taken if valid_users.find_by("LOWER(nickname)= ? AND decidim_organization_id = ?", nickname.downcase, current_organization.id).present?
        end

        def valid_users
          UserBaseEntity.where(invitation_token: nil)
        end
      end
    end
  end
end
