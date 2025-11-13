# frozen_string_literal: true

module SpamProtect
  module Errors
    class NoSecretKey < Error
      def message
        "No secret key available for signing/encryption. Please set `SpamProtect.config.signature_secret` or ensure Rails is loaded with a valid `secret_key_base`."
      end
    end
  end
end
