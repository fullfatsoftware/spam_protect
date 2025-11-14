# frozen_string_literal: true

require "spec_helper"

RSpec.describe SpamProtect::ControllerHelpers do
  let(:controller) { Class.new { include SpamProtect::ControllerHelpers }.new }

  before do
    allow(controller).to receive(:cookies).and_return({"spam_protect_token" => cookie_token})
  end

  describe "#validate_spam_protect_params" do
    let(:token_now) do
      SpamProtect::Encryption.encrypt(
        SpamProtect::Encryption::Payload.generate.to_h
      )
    end

    let(:token_earlier) do
      SpamProtect::Encryption.encrypt(
        SpamProtect::Encryption::Payload.new({timestamp: Time.now.to_i - 10, expires_at: Time.now.to_i + 3600}).to_h
      )
    end

    let(:cookie_token) do
      SpamProtect::Encryption.encrypt(
        SpamProtect::Encryption::Payload.new({timestamp: Time.now.to_i - 10, expires_at: Time.now.to_i + 3600}).to_h
      )
    end

    it "returns false when honeypot has value" do
      params = ActionController::Parameters.new(spam_check: "I am a bot", spam_timestamp: token_earlier)
      expect(controller.validate_spam_protect_params(params)).to eq(false)
    end

    it "raises when timestamp is missing" do
      params = ActionController::Parameters.new(spam_check: "")
      expect { controller.validate_spam_protect_params(params) }.to raise_error { ArgumentError.new "params must include both spam_check and spam_timestamp keys. Have you passed in params[:<model_name>]?" }
    end

    it "raises when params is not ActionController::Parameters" do
      params = {spam_check: "", spam_timestamp: token_earlier}
      expect { controller.validate_spam_protect_params(params) }.to raise_error { ArgumentError.new "params must be an instance of ActionController::Parameters" }
    end

    it "returns false when submitted too quickly" do
      params = ActionController::Parameters.new(spam_check: "", spam_timestamp: token_now)
      expect(controller.validate_spam_protect_params(params, min_seconds: 60)).to eq(false)
    end

    it "returns true for valid submission" do
      params = ActionController::Parameters.new(spam_check: "", spam_timestamp: token_earlier)
      expect(controller.validate_spam_protect_params(params)).to eq(true)
    end
  end
end
