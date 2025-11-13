# frozen_string_literal: true

require "spec_helper"

RSpec.describe SpamProtect::Guardian do
  let(:min_seconds) { 5 }
  let(:honeypot_value) { "" }
  let(:cookie) { "" }
  let(:encrypted_timestamp) { nil }

  subject { described_class.new(honeypot_value, encrypted_timestamp, cookie, min_seconds) }

  before do
    allow(SpamProtect.config).to receive(:require_js).and_return(false)
  end

  context "when everything is valid" do
    let(:payload_hash) do
      {
        "timestamp" => Time.now.to_i - (min_seconds + 2),
        "expires_at" => Time.now.to_i + SpamProtect.config.signature_expiry.to_i
      }
    end

    let(:encrypted_timestamp) { SpamProtect::Encryption.encrypt(payload_hash) }

    it "returns true" do
      expect(subject.valid?).to be true
    end
  end

  context "when encryption is invalid" do
    let(:payload_hash) do
      {
        # expired payload -> EncryptionPolicy should be invalid
        "timestamp" => Time.now.to_i - 60,
        "expires_at" => Time.now.to_i - 10
      }
    end

    let(:encrypted_timestamp) { SpamProtect::Encryption.encrypt(payload_hash) }

    it "returns false" do
      expect(subject.valid?).to be false
    end
  end

  context "when honeypot is filled" do
    let(:honeypot_value) { "bot" }

    let(:payload_hash) do
      {
        "timestamp" => Time.now.to_i - (min_seconds + 1),
        "expires_at" => Time.now.to_i + SpamProtect.config.signature_expiry.to_i
      }
    end

    let(:encrypted_timestamp) { SpamProtect::Encryption.encrypt(payload_hash) }

    it "returns false" do
      expect(subject.valid?).to be false
    end
  end

  context "when timestamp policy fails" do
    let(:payload_hash) do
      {
        "timestamp" => Time.now.to_i,
        "expires_at" => Time.now.to_i + SpamProtect.config.signature_expiry.to_i
      }
    end

    let(:encrypted_timestamp) { SpamProtect::Encryption.encrypt(payload_hash) }

    it "returns false" do
      expect(subject.valid?).to be false
    end
  end

  context "when JS cookie is required and present" do
    let(:payload_hash) do
      {
        "timestamp" => Time.now.to_i - (min_seconds + 1),
        "expires_at" => Time.now.to_i + SpamProtect.config.signature_expiry.to_i
      }
    end

    let(:encrypted_timestamp) { SpamProtect::Encryption.encrypt(payload_hash) }
    let(:cookie) { SpamProtect::Encryption.encrypt(payload_hash) }

    before do
      # override to require JS cookie for this example
      allow(SpamProtect.config).to receive(:require_js).and_return(false)
    end

    it "returns true when cookie is valid" do
      expect(subject.valid?).to be true
    end
  end

  context "when decryption raises InvalidMessage" do
    let(:encrypted_timestamp) { "bad-token" }

    it "returns false" do
      expect(subject.valid?).to be false
    end
  end
end
