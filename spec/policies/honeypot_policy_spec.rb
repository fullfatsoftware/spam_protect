require "spec_helper"

RSpec.describe SpamProtect::Policies::HoneypotPolicy do
  it "valid when value is nil" do
    policy = described_class.new(nil)
    expect(policy.valid?).to be true
  end

  it "valid when value is blank" do
    policy = described_class.new("")
    expect(policy.valid?).to be true
  end

  it "invalid when value present" do
    policy = described_class.new("bot")
    expect(policy.valid?).to be false
  end
end
