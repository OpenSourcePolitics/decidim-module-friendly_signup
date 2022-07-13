# frozen_string_literal: true

require "spec_helper"
require_relative "examples/invitation_password_examples"

describe "Admin invite", type: :system do
  it_behaves_like "on/off invitation passwords"
end
