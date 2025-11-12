# frozen_string_literal: true

require "spec_helper"

RSpec.describe SpamProtect::Encryption::Payload do
  describe ".generate" do
    it "creates a payload with timestamp and expires_at" do
      payload = described_class.generate

      expect(payload).to be_a(described_class)
      expect(payload.timestamp).to be_a(Integer)
      expect(payload.expires_at).to be_a(Integer)
      expect(payload.expires_at).to be > payload.timestamp
    end
  end

  describe "#to_h" do
    it "returns a hash representation of the payload" do
      payload = described_class.new({
        timestamp: 1234567890,
        expires_at: 1234567990
      })

      expect(payload.to_h).to eq({
        "timestamp" => 1234567890,
        "expires_at" => 1234567990
      })
    end
  end

  describe "#[]" do
    it "allows access to payload values via string or symbol keys" do
      payload = described_class.new({
        timestamp: 1234567890,
        expires_at: 1234567990
      })

      expect(payload["timestamp"]).to eq(1234567890)
      expect(payload[:timestamp]).to eq(1234567890)
      expect(payload["expires_at"]).to eq(1234567990)
      expect(payload[:expires_at]).to eq(1234567990)
    end
  end

  describe "#expires_at" do
    it "returns the expires_at value" do
      payload = described_class.new({
        timestamp: 1234567890,
        expires_at: 1234567990
      })

      expect(payload.expires_at).to eq(1234567990)
    end
  end

  describe "#timestamp" do
    it "returns the timestamp value" do
      payload = described_class.new({
        timestamp: 1234567890,
        expires_at: 1234567990
      })

      expect(payload.timestamp).to eq(1234567890)
    end
  end

  describe "#expires_at?" do
    it "returns truthy when present" do
      payload = described_class.new({
        timestamp: 1234567890,
        expires_at: 1234567990
      })

      expect(payload.expires_at?).to be_truthy
    end

    it "returns falsy when missing" do
      payload = described_class.new({
        timestamp: 1234567890
      })

      expect(payload.expires_at?).to be_falsy
    end
  end

  describe "#timestamp?" do
    it "returns truthy when present" do
      payload = described_class.new({
        timestamp: 1234567890,
        expires_at: 1234567990
      })

      expect(payload.timestamp?).to be_truthy
    end

    it "returns falsy when missing" do
      payload = described_class.new({
        expires_at: 1234567990
      })

      expect(payload.timestamp?).to be_falsy
    end
  end
end
