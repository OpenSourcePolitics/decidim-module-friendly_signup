import PasswordToggler from "src/decidim/friendly_signup/lib/password_toggler";

$(() => {
  window.Decidim = window.Decidim || {};
  window.Decidim.passwordToggler = new PasswordToggler($(".user-password"), $(".user-password-confirmation"));
  window.Decidim.passwordToggler.init();
});
