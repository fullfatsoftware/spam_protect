# frozen_string_literal: true

module SpamProtect
  module Encryption
    class SecretKey
      class << self
        def relevant_key!
          result = from_configuration || from_rails

          unless result.present?
            raise Errors::NoSecretKey.new
          end

          unless defined?(ActiveSupport::KeyGenerator) && defined?(ActiveSupport::MessageEncryptor)
            raise Errors::EncryptionUnavailable.new
          end

          key_len = ActiveSupport::MessageEncryptor.key_len

          ActiveSupport::KeyGenerator.new(result).generate_key("spam_protect", key_len)
        end

        private

        def from_configuration
          SpamProtect.config.signature_secret
        end

        def from_rails
          (defined?(Rails) && Rails.application.respond_to?(:secret_key_base)) ? Rails.application.secret_key_base : nil
        end
      end
    end
  end
end
