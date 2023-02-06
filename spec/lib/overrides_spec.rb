# frozen_string_literal: true

require "spec_helper"

# We make sure that the checksum of the file overriden is the same
# as the expected. If this test fails, it means that the overriden
# file should be updated to match any change/bug fix introduced in the core
checksums = [
  {
    package: "decidim-core",
    files: {
      "/app/views/decidim/devise/registrations/new.html.erb" => "a5c41982216b2a22b90816e66cb8286b",
      "/app/views/decidim/devise/passwords/edit.html.erb" => "ea44db0114e1c201cc0f490b4899b8a8",
      "/app/views/decidim/devise/invitations/edit.html.erb" => "435073cbee6b4aaa18da7932e449e6bb",
      "/app/views/decidim/devise/sessions/new.html.erb" => "1da8569a34bcd014ffb5323c96391837",
      "/app/views/decidim/account/_password_fields.html.erb" => "1f0c1dfc65f96f258e6fad41af41c51a",
      "/app/forms/decidim/registration_form.rb" => "32b55eb5a1742b6b8ed7bbb4c7643dc0",
      "/app/controllers/decidim/devise/registrations_controller.rb" => "a98113386111645ec6e4a9e3144aca23",
      "/app/models/decidim/user.rb" => "4aff1b94255db5ffa8868a0f2876c14f"
    }
  }
]

describe "Overriden files", type: :view do
  checksums.each do |item|
    # rubocop:disable Rails/DynamicFindBy
    spec = ::Gem::Specification.find_by_name(item[:package])
    # rubocop:enable Rails/DynamicFindBy
    item[:files].each do |file, signature|
      it "#{spec.gem_dir}#{file} matches checksum" do
        expect(md5("#{spec.gem_dir}#{file}")).to eq(signature)
      end
    end
  end

  private

  def md5(file)
    Digest::MD5.hexdigest(File.read(file))
  end
end
