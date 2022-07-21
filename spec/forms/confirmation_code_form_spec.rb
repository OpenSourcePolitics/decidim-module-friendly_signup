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

    def generate_code(string)
      ::Decidim::FriendlySignup.confirmation_code(string)
    end

    let(:organization) { create(:organization) }
    let!(:user) { create(:user, organization: organization) }
    let(:code) { generate_code(confirmation_token) }
    let(:confirmation_numbers) { [1, 2, 3, 4] }
    let(:confirmation_token) { user.confirmation_token }

    let(:attributes) do
      {
        code: code,
        confirmation_numbers: confirmation_numbers,
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

      it "confirmation_numbers array is ignored" do
        expect(subject.user_code).to eq(code)
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

      context "and confirmation_numbers are correct" do
        let(:confirmation_numbers) { generate_code(confirmation_token).to_s.split("") }

        it { is_expected.to be_valid }
      end
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
