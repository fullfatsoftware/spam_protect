# frozen_string_literal: true

require "spec_helper"

RSpec.describe SpamProtect::Policies::EncryptionPolicy do
  describe "#valid?" do
    it "is valid when payload has correct shape and timestamps" do
      payload = SpamProtect::Encryption::Payload.new({
        timestamp: (Time.now - 10).to_i,
        expires_at: (Time.now + 10).to_i
      })

      policy = described_class.new(payload)
      expect(policy.valid?).to be_truthy
    end

    it "is invalid when payload is missing keys" do
      payload = SpamProtect::Encryption::Payload.new({
        timestamp: (Time.now - 10).to_i
      })

      policy = described_class.new(payload)
      expect(policy.valid?).to be_falsey
    end

    it "is invalid when current time is before timestamp" do
      payload = SpamProtect::Encryption::Payload.new({
        timestamp: (Time.now + 10).to_i,
        expires_at: (Time.now + 20).to_i
      })

      policy = described_class.new(payload)
      expect(policy.valid?).to be_falsey
    end

    it "is invalid when current time is after expires_at" do
      payload = SpamProtect::Encryption::Payload.new({
        timestamp: (Time.now - 20).to_i,
        expires_at: (Time.now - 10).to_i
      })

      policy = described_class.new(payload)
      expect(policy.valid?).to be_falsey
    end
  end
end
