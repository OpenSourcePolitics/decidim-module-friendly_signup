# frozen_string_literal: true

shared_examples "on/off change passwords" do
  context "when override_passwords is active" do
    it "does not show password confirmation" do
      visit last_email_link

      within ".new_user" do
        expect(page).not_to have_field("password_user_password_confirmation")

        fill_in :password_user_password, with: "DfyvHn425mYAy2HL"
        find("*[type=submit]").click
      end

      expect(page).to have_content("Your password has been successfully changed")
      expect(page).to have_current_path "/"
    end
  end

  context "when override_passwords is not active" do
    before do
      allow(Decidim::FriendlySignup).to receive(:override_passwords).and_return(false)
    end

    it "shows password confirmation" do
      visit last_email_link

      within ".new_user" do
        expect(page).to have_field("password_user_password_confirmation")

        fill_in :password_user_password, with: "DfyvHn425mYAy2HL"
        find("*[type=submit]").click
        expect(page).to have_content("doesn't match Password")

        fill_in :password_user_password, with: "DfyvHn425mYAy2HL"
        fill_in :password_user_password_confirmation, with: "DfyvHn425mYAy2HL"
        find("*[type=submit]").click
      end

      expect(page).to have_content("Your password has been successfully changed")
      expect(page).to have_current_path "/"
    end
  end
end
