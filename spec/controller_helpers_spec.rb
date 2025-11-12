# frozen_string_literal: true

require "spec_helper"

RSpec.describe SpamProtect::ControllerHelpers do
  let(:controller) { Class.new { include SpamProtect::ControllerHelpers }.new }

  it "returns false when honeypot has value" do
    params = {spam_check: "I am a bot", spam_timestamp: Time.now.to_i}
    expect(controller.validate_spam_protect_params(params)).to eq(false)
  end

  it "returns false when timestamp is missing" do
    params = {spam_check: ""}
    expect(controller.validate_spam_protect_params(params)).to eq(false)
  end

  it "returns false when submitted too quickly" do
    params = {spam_check: "", spam_timestamp: Time.now.to_i}
    expect(controller.validate_spam_protect_params(params, min_seconds: 60)).to eq(false)
  end

  it "returns true for valid submission" do
    params = {spam_check: "", spam_timestamp: (Time.now - 5).to_i}
    expect(controller.validate_spam_protect_params(params, min_seconds: 2)).to eq(true)
  end
end
