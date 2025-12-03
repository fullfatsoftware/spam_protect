# frozen_string_literal: true

require "spec_helper"

RSpec.describe SpamProtect::ViewHelpers do
  let(:helper) { Class.new { include SpamProtect::ViewHelpers }.new }

  before do
    SpamProtect.config.signature_secret = "test-signature-secret"
  end

  describe "#spam_protect_javascript_tag" do
    it "returns an html_safe script tag" do
      result = helper.spam_protect_javascript_tag
      expect(result).to be_html_safe
      expect(result).to include("<script>")
      expect(result).to include("</script>")
    end

    it "sets the spam_protect_token cookie in the script" do
      result = helper.spam_protect_javascript_tag
      expect(result).to include("spam_protect_token=")
      expect(result).to include("document.cookie")
    end

    it "includes an encrypted token" do
      result = helper.spam_protect_javascript_tag
      # The token should be a non-empty JSON string embedded in the JS
      expect(result).to match(/var token = ".+"/)
    end

    context "without nonce" do
      it "renders a script tag without a nonce attribute" do
        result = helper.spam_protect_javascript_tag
        expect(result).to start_with("<script>")
        expect(result).not_to include("nonce=")
      end
    end

    context "with nonce" do
      it "renders a script tag with the nonce attribute" do
        result = helper.spam_protect_javascript_tag(nonce: "abc123")
        expect(result).to start_with('<script nonce="abc123">')
      end

      it "HTML-escapes the nonce to prevent injection" do
        result = helper.spam_protect_javascript_tag(nonce: '"><script>alert(1)</script>')
        expect(result).not_to include('"><script>alert(1)</script>')
        expect(result).to include("&quot;&gt;&lt;script&gt;alert(1)&lt;/script&gt;")
      end
    end
  end
end
