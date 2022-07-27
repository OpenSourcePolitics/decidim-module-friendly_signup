# frozen_string_literal: true

require "spec_helper"
require_relative "examples/other_password_examples"

describe "Sign in", type: :system do
  let(:organization) { create(:organization) }

  before do
    switch_to_host(organization.host)
  end

  it_behaves_like "on/off sign in passwords"
end
