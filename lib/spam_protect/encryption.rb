# frozen_string_literal: true

require "active_support/message_encryptor"
require "active_support/key_generator"

module SpamProtect
  module Encryption
    module_function

    # Encrypt and sign a payload (hash). Returns a token string or nil on failure.
    def encrypt(payload)
      encryptor = ActiveSupport::MessageEncryptor.new(secret_key)
      encryptor.encrypt_and_sign(payload)
    end

    # Decrypt and verify a token. Returns the payload (usually a Hash) or nil.
    def decrypt(token)
      encryptor = ActiveSupport::MessageEncryptor.new(key)
      encryptor.decrypt_and_verify(token)
    end

    def secret_key
      SecretKey.relevant_key!
    end
  end
end
