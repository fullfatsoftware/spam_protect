# frozen_string_literal: true

require "spec_helper"

RSpec.describe SpamProtect::Encryption do
  describe ".encrypt and .decrypt" do
    let(:secret) { ActiveSupport::KeyGenerator.new("password").generate_key("salt", 32) }

    before do
      # Stub the SecretKey.relevant_key! to return the raw secret we control
      allow(SpamProtect::Encryption::SecretKey).to receive(:relevant_key!).and_return(secret)
    end

    it "encrypts and decrypts a payload (round-trip)" do
      payload = {"user_id" => 123, "ts" => Time.now.to_i}

      token = described_class.encrypt(payload)

      expect(token).to be_a(String)

      result = described_class.decrypt(token)

      expect(result).to eq(payload)
    end

    it "returns nil or raises when decrypting invalid token" do
      # For an invalid token, MessageEncryptor raises ActiveSupport::MessageVerifier::InvalidSignature
      # We'll assert that decrypt raises an error for an invalid token
      expect { described_class.decrypt("invalid-token") }.to raise_error(StandardError)
    end
  end
end
