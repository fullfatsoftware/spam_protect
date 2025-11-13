# frozen_string_literal: true

require "bundler/setup"
require "spam_protect"
require "securerandom"

RSpec.configure do |config|
  SpamProtect.configure do |c|
    c.honeypot_field = :spam_check
    c.timestamp_field = :spam_timestamp
    c.honeypot_class = "spam_protect_honeypot"
    c.signature_secret = SecureRandom.hex(64)
  end

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
