# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/friendly_signup/version"

Gem::Specification.new do |s|
  s.version = Decidim::FriendlySignup::VERSION
  s.authors = ["Ivan Vergés"]
  s.email = ["ivan@pokecode.net"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/decidim/decidim-module-friendly_signup"
  s.required_ruby_version = ">= 3.0"

  s.name = "decidim-friendly_signup"
  s.summary = "A decidim friendly_signup module"
  s.description = "A more user friendly approach for the user registration process."

  s.files = Dir["{app,config,lib}/**/*", "LICENSE-AGPLv3.txt", "package.json", "package-lock.json", "Rakefile", "README.md"]

  s.add_dependency "decidim-core", Decidim::FriendlySignup::COMPAT_DECIDIM_VERSION

  s.add_development_dependency "decidim-dev", Decidim::FriendlySignup::COMPAT_DECIDIM_VERSION
end
