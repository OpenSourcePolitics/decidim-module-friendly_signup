# frozen_string_literal: true

shared_examples "user sign in" do
  it "signs in the user" do
    find(".sign-in-link").click

    within ".new_user" do
      fill_in :session_user_email, with: user.email
      fill_in :session_user_password, with: password
      find("*[type=submit]").click
    end

    expect(page).to have_content("Signed in successfully.")
    expect(page).to have_current_path(decidim.root_path)
  end
end

shared_examples "on/off sign in passwords" do
  let(:password) { "DfyvHn425mYAy2HL" }
  let!(:user) { create(:user, :confirmed, organization: organization, password: password, password_confirmation: password) }

  context "when override_passwords is active" do
    before do
      visit decidim.new_user_session_path
    end

    it "There is a show password button" do
      expect(page).to have_field("session_user_password")
      expect(page).not_to have_field("session_user_password_confirmation")
      expect(page).to have_css(".user-password")
      expect(page).to have_css(".user-password title", text: "Show password")
    end

    it_behaves_like "user sign in"
  end

  context "when override_passwords is not active" do
    before do
      allow(Decidim::FriendlySignup).to receive(:override_passwords).and_return(false)
      visit decidim.new_user_session_path
    end

    it "There is a show password button" do
      expect(page).to have_field("session_user_password")
      expect(page).not_to have_field("session_user_password_confirmation")
      expect(page).not_to have_css(".user-password")
    end

    it_behaves_like "user sign in"
  end
end
