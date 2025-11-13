# frozen_string_literal: true

require "spec_helper"

RSpec.describe SpamProtect::CurrentTime do
  describe ".now" do
    it "returns Time.current when available" do
      fake_time = Time.new(2020, 1, 2, 3, 4, 5)

      allow(Time).to receive(:respond_to?).with(:current).and_return(true)
      allow(Time).to receive(:current).and_return(fake_time)

      expect(described_class.now).to eq(fake_time)
    end

    it "falls back to Time.now when Time.current is not available" do
      fake_time = Time.new(2019, 12, 31, 23, 59, 59)

      allow(Time).to receive(:respond_to?).with(:current).and_return(false)
      allow(Time).to receive(:now).and_return(fake_time)

      expect(described_class.now).to eq(fake_time)
    end
  end
end
