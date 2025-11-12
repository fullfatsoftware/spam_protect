# frozen_string_literal: true

module SpamProtect
  class Guardian
    def initialize(honeypot_value, encrypted_timestamp, min_seconds)
      @honeypot_value = honeypot_value
      @encrypted_timestamp = encrypted_timestamp
      @min_seconds = min_seconds
    end

    def valid?
      payload = SpamProtect::Encryption.decrypt(@encrypted_timestamp)

      encryption_policy = Policies::EncryptionPolicy.new(payload, @min_seconds)

      return false if !encryption_policy.invalid?

      honeypot_policy = Policies::HoneypotPolicy.new(@honeypot_value)

      return false if honeypot_policy.invalid?

      timestamp_policy = Policies::TimestampPolicy.new(payload["timestamp"], @min_seconds)

      timestamp_policy.valid?
    end
  end
end
