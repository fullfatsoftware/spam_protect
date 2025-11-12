# frozen_string_literal: true

module SpamProtect
  module ControllerHelpers
    def validate_spam_protect_params(params, honeypot_key: nil, timestamp_key: nil, min_seconds: nil)
      honeypot_key ||= SpamProtect.config.honeypot_field
      timestamp_key ||= SpamProtect.config.timestamp_field
      min_seconds ||= SpamProtect.config.min_seconds

      honeypot_value = params[honeypot_key]
      encrypted_timestamp = params[timestamp_key]

      guardian = SpamProtect::Guardian.new(honeypot_value, encrypted_timestamp, min_seconds)
      guardian.valid?
    end
  end
end
