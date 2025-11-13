# frozen_string_literal: true

require "spec_helper"

RSpec.describe SpamProtect::Encryption::SecretKey do
  describe ".relevant_key!" do
    around do |example|
      original = SpamProtect.config.signature_secret
      begin
        example.run
      ensure
        SpamProtect.config.signature_secret = original
      end
    end

    context "when signature_secret is configured" do
      it "generates a key of the expected length" do
        SpamProtect.config.signature_secret = "supersecret"
        key = described_class.relevant_key!
        expect(key.bytesize).to eq(ActiveSupport::MessageEncryptor.key_len)
      end
    end

    context "when no secret is available" do
      it "raises NoSecretKey" do
        SpamProtect.config.signature_secret = nil
        # ensure Rails isn't providing one
        allow(Rails).to receive(:application).and_return(nil)

        expect { described_class.relevant_key! }.to raise_error(SpamProtect::Errors::NoSecretKey)
      end
    end
  end
end
