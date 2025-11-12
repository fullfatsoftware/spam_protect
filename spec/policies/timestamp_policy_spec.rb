# frozen_string_literal: true

require "spec_helper"

RSpec.describe SpamProtect::Policies::TimestampPolicy do
  it "invalid when timestamp missing" do
    policy = described_class.new(nil, 2)
    expect(policy.valid?).to be false
  end

  it "invalid when timestamp is too recent" do
    policy = described_class.new(Time.now.to_i, 60)
    expect(policy.valid?).to be false
  end

  it "valid when timestamp is older than min_seconds" do
    policy = described_class.new((Time.now - 5).to_i, 2)
    expect(policy.valid?).to be true
  end
end
