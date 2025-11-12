# frozen_string_literal: true

module SpamProtect
  module Encryption
    class Payload
      def self.generate
        {
          timestamp: CurrentTime.now.to_i,
          expires_at: CurrentTime.now.to_i + SpamProtect.config.signature_expiry.to_i
        }
      end
    end
  end
end
