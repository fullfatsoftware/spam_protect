# frozen_string_literal: true

require "spec_helper"

RSpec.describe SpamProtect::Policies::CookiePolicy do
  let(:js_required) { true }

  before do
    allow(SpamProtect.config).to receive(:require_js).and_return(js_required)
  end

  let(:valid_payload) { "some cookie value" }

  context "when JS is not required" do
    let(:js_required) { false }

    it "is valid even when cookie is blank" do
      policy = described_class.new("")
      expect(policy.valid?).to be_truthy
    end
  end

  context "when JS is required" do
    let(:js_required) { true }

    it "is valid with a present string" do
      policy = described_class.new(valid_payload)
      expect(policy.valid?).to be_truthy
    end

    it "is invalid when cookie is missing" do
      policy = described_class.new("")

      expect(policy.valid?).to be_falsey
    end
  end
end
