# frozen_string_literal: true

# Example initializer for spam_protect
SpamProtect.configure do |config|
  # Custom field names (symbols)
  # config.honeypot_field = :hp_phone
  # config.timestamp_field = :hp_ts

  # CSS class applied to the honeypot field
  # config.honeypot_class = "sp_hp"
  # config.wrapper_class = "spam_protect"

  # Require JavaScript checks
  # config.require_js = true # Default is true

  # Minimum seconds required between form render and submission
  # config.min_seconds = 3

  # Secret key for signing/encrypting timestamps
  # config.signature_secret = SecureRandom.hex(64) # Will default to Rails secret_key_base if nil

  # Expiry duration for the signature
  # config.signature_expiry = 6.hours
end
