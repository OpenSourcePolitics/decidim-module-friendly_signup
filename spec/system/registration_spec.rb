# frozen_string_literal: true

require "spec_helper"
require_relative "examples/registration_password_examples"

describe "Registration", type: :system do
  let(:organization) { create(:organization) }

  before do
    switch_to_host(organization.host)
  end

  it_behaves_like "on/off registration passwords"
end
