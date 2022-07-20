# frozen_string_literal: true

require "spec_helper"

module Decidim::FriendlySignup
  describe ConfirmationCodeForm do
    subject do
      described_class.from_params(
        attributes
      ).with_context(
        context
      )
    end

    let(:organization) { create(:organization) }
    let!(:user) { create(:user, organization: organization) }
    let(:code) { Decidim::Tokenizer.new(salt: Rails.application.secret_key_base, length: 2).int_digest(confirmation_token) }
    let(:confirmation_token) { user.confirmation_token }

    let(:attributes) do
      {
        code: code,
        confirmation_token: confirmation_token
      }
    end

    let(:context) do
      {
        current_organization: organization
      }
    end

    context "when code exists" do
      it "is valid" do
        expect(subject).to be_valid
        expect(subject.errors[:code]).to be_empty
      end

      context "and code is invalid" do
        let(:code) { "1234" }

        it "is invalid" do
          expect(subject).to be_invalid
          expect(subject.errors[:code]).not_to be_empty
        end
      end
    end

    context "when code is empty" do
      let(:code) { nil }

      it { is_expected.to be_invalid }
    end

    context "when confirmation_token is empty" do
      let(:confirmation_token) { nil }

      it { is_expected.to be_invalid }
    end

    context "when confirmation_token does not match the user" do
      let(:confirmation_token) { "anothertoken" }

      it { is_expected.to be_invalid }
    end

    context "when is already confirmed" do
      let(:user) { create(:user, :confirmed, organization: organization) }

      it { is_expected.to be_invalid }
    end

    context "when user belongs to another organization" do
      let(:user) { create(:user) }

      it { is_expected.to be_invalid }
    end
  end
end
