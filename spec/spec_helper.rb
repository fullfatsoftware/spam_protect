# frozen_string_literal: true

require "bundler/setup"
require "spam_protect"
require "securerandom"

RSpec.configure do |config|
  SpamProtect.configure do |c|
    c.signature_secret = SecureRandom.hex(64)
  end

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
