# frozen_string_literal: true

module SpamProtect
  module Encryption
    class Payload
      VALID_METHODS = %w[timestamp expires_at].freeze

      def self.generate
        new({
          timestamp: CurrentTime.now.to_i,
          expires_at: CurrentTime.now.to_i + SpamProtect.config.signature_expiry.to_i
        })
      end

      def initialize(hash)
        @hash = hash
      end

      def [](key)
        if VALID_METHODS.include?(key.to_s)
          send(key)
        end
      end

      # force the keys to be strings so we always have a consistent format
      def to_h
        {
          "timestamp" => timestamp,
          "expires_at" => expires_at
        }
      end

      def expires_at
        @hash[:expires_at] || @hash["expires_at"]
      end

      def timestamp
        @hash[:timestamp] || @hash["timestamp"]
      end

      alias_method :expires_at?, :expires_at
      alias_method :timestamp?, :timestamp
    end
  end
end
