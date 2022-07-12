# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe FriendlySignup do
    def gemdep(const)
      Gem::Dependency.new("", Decidim::FriendlySignup.const_get(const))
    end

    def gemspec(loaded_gem = "decidim-friendly_signup")
      Gem.loaded_specs[loaded_gem]
    end

    it "has a version number" do
      expect(described_class::VERSION).not_to be nil
      expect(described_class::VERSION).to eq(gemspec.version.to_s)
    end

    it "has a decidim version number for development" do
      expect(described_class::DECIDIM_VERSION).not_to be nil
      expect(described_class::DECIDIM_VERSION).to eq(gemspec("decidim").version.to_s)
    end

    it "has a compatible-decidim version number" do
      expect(described_class::COMPAT_DECIDIM_VERSION).not_to be nil
      gemspec.dependencies.each do |spec|
        expect(spec.requirements_list.first).to eq(described_class::COMPAT_DECIDIM_VERSION)
      end
      expect(gemdep(:COMPAT_DECIDIM_VERSION)).to be_match("", Decidim.version)
    end
  end
end
