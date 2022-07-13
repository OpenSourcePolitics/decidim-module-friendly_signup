# frozen_string_literal: true

require "spec_helper"

module Decidim::FriendlySignup
  describe ValidatorController, type: :controller do
    routes { Decidim::FriendlySignup::Engine.routes }

    let(:organization) { create(:organization) }

    before do
      request.env["decidim.current_organization"] = organization
    end

    describe "POST validate" do
      let(:params) do
        {
          attribute: "nickname",
          nickname: "agentsmith"
        }
      end

      shared_examples "a valid Json object" do
        it "responds successfully" do
          post :validate, params: params

          expect(response).to have_http_status(:success)
          expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
        end
      end

      it_behaves_like "a valid Json object"

      it "returns valid property" do
        post :validate, params: params

        json = JSON.parse(response.body)
        expect(json["valid"]).to be(true)
      end

      context "when nickname exists" do
        let!(:user) { create(:user, organization: organization, nickname: "agentsmith") }

        it_behaves_like "a valid Json object"

        it "returns invalid property" do
          post :validate, params: params

          json = JSON.parse(response.body)
          expect(json["valid"]).to be(false)
          expect(json["error"]).to eq("Has already been taken")
        end
      end

      context "when parameters are missing" do
        let(:params) { {} }

        it_behaves_like "a valid Json object"

        it "returns invalid property" do
          post :validate

          json = JSON.parse(response.body)
          expect(json["valid"]).to be(false)
          expect(json["error"]).to eq("Invalid attribute")
        end
      end
    end
  end
end
