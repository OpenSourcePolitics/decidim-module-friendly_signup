# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe RegistrationForm do
    subject do
      described_class.from_params(
        attributes
      ).with_context(
        context
      )
    end

    let(:organization) { create(:organization) }
    let(:name) { "User" }
    let(:nickname) { "justme" }
    let(:email) { "user@example.org" }
    let(:password) { "S4CGQ9AM4ttJdPKS" }
    let(:password_confirmation) { password }
    let(:tos_agreement) { "1" }

    let(:attributes) do
      {
        name: name,
        email: email,
        password: password,
        password_confirmation: password_confirmation,
        tos_agreement: tos_agreement
      }
    end

    let(:context) do
      {
        current_organization: organization
      }
    end

    context "when hide_nickname is active" do
      it { is_expected.to be_valid }

      it "generates a nickname" do
        expect(subject.nickname).to eq("user")
      end
    end

    context "when hide_nickname is inactive" do
      before do
        allow(Decidim::FriendlySignup).to receive(:hide_nickname).and_return(false)
      end

      it { is_expected.to be_invalid }

      it "does not generate a nickname" do
        expect(subject.nickname).to be_blank
      end

      context "when everything is OK" do
        let(:attributes) do
          {
            name: name,
            nickname: nickname,
            email: email,
            password: password,
            password_confirmation: password_confirmation,
            tos_agreement: tos_agreement
          }
        end

        it { is_expected.to be_valid }

        it "uses params nickname" do
          expect(subject.nickname).to eq("justme")
        end
      end
    end

    context "when email contains a script tag" do
      let(:email) { "<script>alert('XSS')</script>@example.org" }

      it { is_expected.to be_invalid }
    end
  end
end
