# frozen_string_literal: true

module Decidim
  module FriendlySignup
    class UserAttributeValidator
      def initialize(attribute:, form:)
        @attribute = attribute
        @form = form
      end

      delegate :current_organization, to: :form
      attr_reader :attribute, :form

      def valid?
        @valid ||= begin
          form.validate
          # we don't validate the form but the attribute alone
          errors.blank?
        end
      end

      def input
        @input ||= form.public_send(attribute).to_s.dup if valid_attribute?
      end

      def errors
        @errors ||= valid_attribute? ? form.errors[attribute] : ["Invalid attribute"]
      end

      def error
        return if valid?

        errors.map do |msg|
          key = find_key(msg)
          next if key == :nickname_included_in_password && FriendlySignup.hide_nickname.present?

          custom_error(key).presence || msg.upcase_first
        end.join(".<br>")
      end

      private

      def custom_error(key)
        return if key.blank?

        generic = I18n.t(key, scope: "decidim.friendly_signup.errors.messages", default: "")
        I18n.t("#{attribute}.#{key}", scope: "decidim.friendly_signup.errors.messages", default: generic)
      end

      def find_key(msg)
        case attribute
        when "password"
          [:blacklisted,
           :domain_included_in_password,
           :email_included_in_password,
           :fallback,
           :name_included_in_password,
           :nickname_included_in_password,
           :not_enough_unique_characters,
           :password_not_allowed,
           :password_too_common,
           :password_too_long,
           :password_too_short].find { |key| msg == I18n.t(key, scope: "password_validator") }
        else
          [:blank, :invalid, :taken].find { |key| msg == I18n.t(key, scope: "errors.messages") }
        end
      end

      def valid_attribute?
        %w(nickname email name password).include? attribute.to_s
      end

      def valid_suggestor?
        ["nickname"].include? attribute.to_s
      end
    end
  end
end
