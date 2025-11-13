# frozen_string_literal: true

module SpamProtect
  class Guardian
    attr_reader :errors

    def initialize(honeypot_value, encrypted_timestamp, cookie, min_seconds)
      @honeypot_value = honeypot_value
      @encrypted_timestamp = encrypted_timestamp
      @cookie = cookie
      @min_seconds = min_seconds
      @errors = []
    end

    def valid?
      payload = Encryption::Payload.new(
        Encryption.decrypt(@encrypted_timestamp)
      )

      cookie_payload = if SpamProtect.config.require_js
        Encryption::Payload.new(
          Encryption.decrypt(@cookie)
        )
      end

      payloads = [
        payload,
        cookie_payload
      ].compact

      honeypot_policy = Policies::HoneypotPolicy.new(@honeypot_value)
      if honeypot_policy.invalid?
        @errors.append "Honeypot field is filled in"
        return false
      end

      cookie_policy = Policies::CookiePolicy.new(@cookie)
      if cookie_policy.invalid?
        @errors.append "Cookie is invalid"
        return false
      end

      payloads.each do |p|
        encryption_policy = Policies::EncryptionPolicy.new(p)
        if encryption_policy.invalid?
          @errors.append "Payload encryption is invalid or expired"
          return false
        end

        timestamp_policy = Policies::TimestampPolicy.new(p["timestamp"], @min_seconds)
        if timestamp_policy.invalid?
          @errors.append "Form submitted too quickly"
          return false
        end
      end

      true
    rescue ActiveSupport::MessageEncryptor::InvalidMessage
      @errors.append "Encryption failure"
      false
    end
  end
end
