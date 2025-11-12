# frozen_string_literal: true

require "spec_helper"

RSpec.describe SpamProtect::Policies::TimestampPolicy do
  describe "#valid?" do
    it "invalid when timestamp missing" do
      policy = described_class.new(nil, 2)
      expect(policy.valid?).to be_falsey
    end

    it "invalid when timestamp is too recent" do
      policy = described_class.new(Time.now.to_i, 60)
      expect(policy.valid?).to be_falsey
    end

    it "valid when timestamp is older than min_seconds" do
      policy = described_class.new((Time.now - 5).to_i, 2)

      expect(policy.valid?).to be_truthy
    end
  end
end
