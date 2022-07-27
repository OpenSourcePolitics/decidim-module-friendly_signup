# frozen_string_literal: true

require "spec_helper"

module Decidim::FriendlySignup
  describe UserAttributeValidator do
    subject { described_class.new(attribute: attribute, form: form) }

    let(:attribute) { "nickname" }
    let(:form) { Decidim::RegistrationForm.from_params(params).with_context(context) }
    let(:params) do
      {
        attribute => input_value
      }
    end
    let(:input_value) { "mali" }
    let(:context) do
      {
        current_organization: organization
      }
    end
    let(:user_value) { "zimbawe" }
    let(:group_value) { "africa" }
    let!(:organization) { create :organization }

    before do
      allow(Decidim::FriendlySignup).to receive(:hide_nickname).and_return(false)
    end

    it "responds to form" do
      expect(subject.form).to eq(form)
    end

    context ""
    it { is_expected.to be_valid }

    it "does not have errors" do
      expect(subject.error).to be_blank
    end

    context "when attribute already belongs to a user" do
      let!(:user) { create :user, :organization => organization, attribute.to_sym => user_value }
      let(:input_value) { "zimbawe" }

      it "returns an error message" do
        expect(subject.error).to include("already been taken")
      end
    end

    # valid when https://github.com/decidim/decidim/pull/9527 is released (0.26.3)
    # context "when attribute already belongs to a group" do
    #   let!(:user_group) { create :user_group, :organization => organization, attribute.to_sym => group_value }
    #   let(:input_value) { "africa" }

    #   it "returns an error message" do
    #     expect(subject.error).to include("already been taken")
    #   end
    # end

    context "when attribute is not supported" do
      let(:attribute) { "about" }

      it { is_expected.not_to be_valid }

      it "returns an error message" do
        expect(subject.error).to include("Invalid attribute")
      end
    end

    context "when attribute has dependant validations" do
      let(:attribute) { "password" }
      let(:name) { "Africa Unite 1979" }
      let(:input_value) { "africaunite1979" }
      let(:params) do
        {
          name: name,
          password: input_value,
          password_confirmation: input_value,
          attribute: attribute
        }
      end

      it { is_expected.not_to be_valid }

      it "returns an custom message" do
        expect(subject.error).to include("The password you have entered is too similar to your name")
      end

      context "and depency is ok" do
        let(:name) { "Survival" }

        it { is_expected.to be_valid }
      end
    end

    context "when attribute has custom error messages" do
      let(:attribute) { "email" }
      let(:name) { "test" }
      let(:input_value) { " " }
      let(:params) do
        {
          name: name,
          nickname: name,
          password: input_value,
          password_confirmation: input_value,
          attribute: attribute
        }
      end

      it "gets custom error" do
        expect(subject.error).to include("Please enter an email address")
      end

      context "when there's no custom translation for the attribute" do
        before do
          allow(I18n).to receive(:t).and_call_original
          allow(I18n).to receive(:t).with("email.blank", scope: "decidim.friendly_signup.errors.messages", default: "Looks like you haven’t entered anything in this field").and_return("")
        end

        it "returns an generic message" do
          expect(subject.error).to include("Can't be blank")
        end
      end

      context "and uses custom validators" do
        let(:attribute) { "password" }
        let(:input_value) { "test" }

        it "gets custom error" do
          expect(subject.error).to include("The password you have entered is too similar to your nickname")
          expect(subject.error).to include("The password you have entered is too similar to your name")
        end

        context "when nickname is hidden" do
          before do
            allow(Decidim::FriendlySignup).to receive(:hide_nickname).and_return(true)
          end

          it "does not show nickname error" do
            expect(subject.error).not_to include("The password you have entered is too similar to your nickname")
            expect(subject.error).to include("The password you have entered is too similar to your name")
          end
        end

        context "when there's no custom translation" do
          before do
            allow(I18n).to receive(:t).and_call_original
            allow(I18n).to receive(:t).with("password.name_included_in_password", scope: "decidim.friendly_signup.errors.messages", default: "").and_return("")
          end

          it "returns an generic message" do
            expect(subject.error).to include("Is too similar to your name")
          end
        end
      end
    end
  end
end
