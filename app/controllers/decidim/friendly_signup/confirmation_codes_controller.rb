# frozen_string_literal: true

module Decidim
  module FriendlySignup
    class ConfirmationCodesController < Decidim::Devise::ConfirmationsController
      include Decidim::FormFactory
      include NeedsHeaderSnippets

      before_action :require_unconfirmed_user
      helper_method :user, :confirmation_form, :stored_location_for

      def index; end

      def create
        if confirmation_form.valid?
          user.confirm
          flash[:success] = I18n.t("confirmation_codes.create.user_confirmed", name: user.name, scope: "decidim.friendly_signup")
          return sign_in_and_redirect user, event: :authentication
        end

        flash.now[:alert] = confirmation_form.errors.messages.values.flatten.join(" ")
        render :index
      end

      def skip
        sign_in_and_redirect user
      end

      private

      def confirmation_form
        @confirmation_form ||= form(ConfirmationCodeForm).from_params(params)
      end

      def user
        @user ||= User.find_by(confirmation_token: params[:confirmation_token], organization: current_organization)
      end

      def require_unconfirmed_user
        return redirect_to decidim.user_confirmation_path unless FriendlySignup.use_confirmation_codes

        unless user.present? && !user.confirmed?
          flash[:alert] = I18n.t("confirmation_code_form.invalid_token", scope: "decidim.friendly_signup")
          return redirect_to decidim.new_user_session_path
        end

        if user.send(:confirmation_period_expired?)
          flash[:alert] = I18n.t("confirmation_code_form.expired", scope: "decidim.friendly_signup")
          redirect_to decidim.user_confirmation_path
        end
      end
    end
  end
end
