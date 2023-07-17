# frozen_string_literal: true

require "spec_helper"

# We make sure that the checksum of the file overriden is the same
# as the expected. If this test fails, it means that the overriden
# file should be updated to match any change/bug fix introduced in the core
checksums = [
  {
    package: "decidim-core",
    files: {
      "/app/views/decidim/devise/registrations/new.html.erb" => "5f6f15330839fa55697c4e272767a090",
      "/app/views/decidim/devise/passwords/edit.html.erb" => "d952fc96b7e00f1df19ff4f2af735932",
      "/app/views/decidim/devise/invitations/edit.html.erb" => "e5762f86c0125adc6339400e1796216a",
      "/app/views/decidim/devise/sessions/new.html.erb" => "9d090fc9e565ded80a9330d4e36e495c",
      "/app/views/decidim/account/_password_fields.html.erb" => "fddb4c742840dac1fb56d02ea959c3f6",
      "/app/forms/decidim/registration_form.rb" => "46b822fa575833b5a84abc705cbc3698",
      "/app/controllers/decidim/devise/registrations_controller.rb" => "315c5b3865ecad9d647b4da98057407f",
      "/app/models/decidim/user.rb" => "4e01470c07505f73622a3ea86e11a120"
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
