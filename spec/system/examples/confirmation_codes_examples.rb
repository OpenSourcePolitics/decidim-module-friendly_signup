# frozen_string_literal: true

shared_examples "on/off confirmation codes" do
  context "when confirmation codes is active" do
    before do
      visit decidim_friendly_signup.confirmation_codes_path(confirmation_token: confirmation_token)
    end

    it "confirms the user" do
      expect(user.reload).not_to be_confirmed

      fill_confirmation_code(code)

      within_flash_messages do
        expect(page).to have_content("Your account has been succesfully confirmed")
      end

      expect(user.reload).to be_confirmed
    end

    it "doesn't propose to skip the confirmation" do
      expect(page).not_to have_content("You can also participate during")
    end

    context "when fast sign_up is activated" do
      before do
        # Mock the value of unconfirmed_access_for to 2 days
        allow(Decidim).to receive(:unconfirmed_access_for).and_return(2.days)

        # Mock the user's active_for_authentication? to always return true
        allow_any_instance_of(Decidim::User).to receive(:active_for_authentication?).and_return(true) # rubocop:disable RSpec/AnyInstance

        # Visit the confirmation_codes_path with a confirmation token
        visit decidim_friendly_signup.confirmation_codes_path(confirmation_token: confirmation_token)
      end

      it "lets you skip the confirmation part" do
        expect(page).to have_content("You can also participate during 2 days")

        click_link "You can also participate during 2 days"

        expect(user.reload).not_to be_confirmed
      end

      context "when we come to the end of the 2 days period" do
        before do
          click_link "You can also participate during 2 days"

          travel_to 3.days.from_now

          allow_any_instance_of(Decidim::User).to receive(:active_for_authentication?).and_return(false) # rubocop:disable RSpec/AnyInstance
        end

        it "redirects you to the confirmation_page after two days" do
          click_link user.name.to_s
          click_link "Sign out"

          expect(page).to have_content("Sign In")

          click_link "Sign In"

          fill_in "Email", with: user.email
          fill_in "Password", with: user.password

          click_button "Log in"

          expect(page).to have_content("Sorry, this code has expired, please generate a new one.")

          fill_in "Email", with: user.email

          click_button "Resend confirmation instructions"

          expect(page).to have_content("You should receive a 4 digit code at #{user.email}")

          expect(page).not_to have_content("You can also participate during 2 days")

          within_flash_messages do
            expect(page).to have_content("A message with a code has been sent to your email address. Please copy and paste the received code in this page.")
          end
        end
      end
    end

    context "when code is incorrect" do
      let(:code) { 1234 }

      it "does not confirm the user" do
        expect(user.reload).not_to be_confirmed

        fill_confirmation_code(code)

        within_flash_messages do
          expect(page).to have_content("Code is invalid")
        end

        expect(user.reload).not_to be_confirmed
      end
    end

    shared_examples "invalid token" do
      it "redirects the user out of here" do
        expect(page).to have_content("Log in")
        within_flash_messages do
          expect(page).to have_content("Invalid token")
        end
      end
    end

    context "when token is incorrect" do
      let(:confirmation_token) { "blabla" }

      it_behaves_like "invalid token"
    end

    context "when user is already confirmed" do
      let!(:user) { create(:user, :confirmed, organization: organization) }

      it_behaves_like "invalid token"
    end
  end

  context "when confirmation codes is not active" do
    before do
      allow(Decidim::FriendlySignup).to receive(:use_confirmation_codes).and_return(false)
      visit decidim_friendly_signup.confirmation_codes_path(confirmation_token: confirmation_token)
    end

    it "redirects to standard confirmation" do
      expect(user.reload).not_to be_confirmed

      expect(page).to have_content("Resend confirmation instructions")

      expect(user.reload.confirmed?).to be(false)
    end
  end
end

shared_examples "on/off standard confirmation" do
  context "when confirmation codes is active" do
    before do
      visit decidim.user_confirmation_path
    end

    it "sends the confirmation code" do
      expect(page).to have_content("Resend confirmation instructions")
      fill_email

      expect(page).to have_content("One last step...")
      within_flash_messages do
        expect(page).to have_content("A message with a code has been sent to your email address")
      end

      expect(user.reload.confirmed?).to be(false)

      expect(last_email.subject).to include(code.to_s)
      expect(last_email.subject).to include(organization.name)
      expect(last_email_code).to eq(code.to_s)
      fill_confirmation_code(last_email_code)

      expect(user.reload).to be_confirmed
    end
  end

  context "when confirmation codes is not active" do
    before do
      allow(Decidim::FriendlySignup).to receive(:use_confirmation_codes).and_return(false)
      visit decidim.user_confirmation_path
    end

    it "sends standard confirmation" do
      clear_emails

      expect(page).to have_content("Resend confirmation instructions")
      fill_email

      expect(page).to have_content("Log in")
      within_flash_messages do
        expect(page).to have_content("If your email address exists in our database, you will receive an email with instructions")
      end

      perform_enqueued_jobs
      visit last_email_link
      expect(page).to have_content("Your email address has been successfully confirmed")
      expect(user.reload).to be_confirmed
    end
  end
end
