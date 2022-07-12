# frozen_string_literal: true

require "spec_helper"

def fill_registration_form
  fill_in :registration_user_name, with: "Nikola Tesla"
  fill_in :registration_user_nickname, with: "the-greatest-genius-in-history"
  fill_in :registration_user_email, with: "nikola.tesla@example.org"
  fill_in :registration_user_password, with: "sekritpass123"
  fill_in :registration_user_password_confirmation, with: "sekritpass123"
end

describe "Registration", type: :system do
  let(:organization) { create(:organization) }

  before do
    switch_to_host(organization.host)
  end

  context "when signing up" do
    it "does not show password confirmation" do
      visit decidim.new_user_registration_path
      expect(page).to have_content("Sign up to participate")
      expect(page).to have_field("registration_user_name", with: "")
      expect(page).to have_field("registration_user_nickname", with: "")
      expect(page).to have_field("registration_user_email", with: "")
      expect(page).to have_field("registration_user_password", with: "")
      expect(page).to have_field("registration_user_newsletter", checked: false)
    end
  end

  context "when override_passwords is not active" do
    before do
      allow(Decidim::FriendlySignup).to receive(:override_passwords).and_return(false)
    end

    it "shows password confirmation" do
      visit decidim.new_user_registration_path
      expect(page).to have_content("Sign up to participate")
      expect(page).to have_field("registration_user_name", with: "")
      expect(page).to have_field("registration_user_nickname", with: "")
      expect(page).to have_field("registration_user_email", with: "")
      expect(page).to have_field("registration_user_password", with: "")
      expect(page).to have_field("registration_user_password_confirmation", with: "")
      expect(page).to have_field("registration_user_newsletter", checked: false)
    end
  end
end
