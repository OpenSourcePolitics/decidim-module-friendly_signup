# frozen_string_literal: true

require "spec_helper"

describe "Registration", type: :system do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, :confirmed, organization: organization) }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
    visit decidim.account_path
  end

  context "when override_passwords is active" do
    it "updates the password successfully" do
      within "form.edit_user" do
        page.find(".change-password").click

        fill_in :user_password, with: "sekritpass123"

        find("*[type=submit]").click
      end

      within_flash_messages do
        expect(page).to have_content("successfully")
      end

      expect(user.reload.valid_password?("sekritpass123")).to eq(true)
    end
  end

  context "when override_passwords is not active" do
    before do
      allow(Decidim::FriendlySignup).to receive(:override_passwords).and_return(false)
      visit decidim.account_path
    end

    it "does not updates the password if confirmation is not filled" do
      within "form.edit_user" do
        page.find(".change-password").click

        fill_in :user_password, with: "sekritpass123"
        find("*[type=submit]").click
      end

      within_flash_messages do
        expect(page).to have_content("There was a problem updating your account.")
      end
    end

    it "updates the password successfully" do
      within "form.edit_user" do
        page.find(".change-password").click

        fill_in :user_password, with: "sekritpass123"
        fill_in :user_password_confirmation, with: "sekritpass123"
        find("*[type=submit]").click
      end

      within_flash_messages do
        expect(page).to have_content("successfully")
      end

      expect(user.reload.valid_password?("sekritpass123")).to eq(true)
    end
  end
end
