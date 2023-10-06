require "spec_helper"

module Decidim
  module FriendlySignup
    RSpec.describe ConfirmationCodesController, type: :controller do
      routes { Decidim::FriendlySignup::Engine.routes }
      let(:decidim_router) { Decidim::Core::Engine.routes.url_helpers }

      let(:current_organization) { create(:organization) }
      let(:valid_code) { 1234 }
      let(:params) { { confirmation_token: user.confirmation_token, code: valid_code } }
      let(:user) { create(:user, organization: current_organization) }

      before do
        request.env["decidim.current_organization"] = current_organization
        allow(FriendlySignup).to receive(:use_confirmation_codes).and_return(true)
        allow(FriendlySignup).to receive(:confirmation_code).with(user.confirmation_token).and_return(valid_code)
        user.invite!
      end

      shared_examples_for "confirmation codes disabled" do
        before do
          allow(FriendlySignup).to receive(:use_confirmation_codes).and_return(false)
        end

        it "redirects to new_user_session_path" do
          post :create, params: params

          expect(response).to redirect_to(decidim_router.user_confirmation_path)
        end
      end

      describe "POST #create" do
        it_behaves_like "confirmation codes disabled"

        context "with a valid form" do
          it "confirms the user and redirects" do
            post :create, params: params

            expect(user.reload).to be_confirmed
            expect(response).to redirect_to(decidim_router.root_path)
            expect(flash[:success]).to be_present
          end

          it "using confirmation_numbers params" do
            post :create, params: {confirmation_token: user.confirmation_token, confirmation_numbers: [1,2,3,4] }

            expect(user.reload).to be_confirmed
            expect(response).to redirect_to(decidim_router.root_path)
            expect(flash[:success]).to be_present
          end
        end

        context "with an invalid form" do
          it "redirects to new_user_session_path with an alert" do
            post :create, params: { code: 9999 }

            expect(response).to redirect_to(decidim_router.new_user_session_path)
            expect(flash.now[:alert]).to be_present
            expect(user.reload).not_to be_confirmed
          end
        end
      end

      describe "GET #skip" do
        it_behaves_like "confirmation codes disabled"

        it "signs in and redirects the user" do
          get :skip, params: params
          expect(response).to redirect_to("/")
        end
      end

      describe "#confirmation_token" do
        before do
          allow(controller).to receive(:params).and_return(confirmation_token: "1234")
        end

        it "returns the confirmation_token" do
          expect(controller.send(:confirmation_token)).to eq("1234")
        end

        context "when confirmation_token is an array" do
          before do
            allow(controller).to receive(:params).and_return(confirmation_token: ["1234", "4567", "6789"])
          end

          it "returns the first confirmation_token" do
            expect(controller.send(:confirmation_token)).to eq("1234")
          end
        end
      end
    end
  end
end
