# frozen_string_literal: true

require "spec_helper"
require "action_controller"

RSpec.describe SpamProtect::FormBuilderMethods do
  let(:view) do
    lookup = ActionView::LookupContext.new(ActionView::PathSet.new)
    assigns = {}
    controller = ActionController::Base.new
    ActionView::Base.new(lookup, assigns, controller)
  end

  describe "#spam_protect_field" do
    before do
      ActionView::Helpers::FormBuilder.include(SpamProtect::FormBuilderMethods)
      # Create a minimal form builder instance
      @builder = ActionView::Helpers::FormBuilder.new(:user, Object.new, view, {})
    end

    it "renders honeypot and timestamp fields" do
      output = @builder.spam_protect_field
      expect(output).to include("spam_check")
      expect(output).to include("spam_timestamp")
    end

    it "includes the configured honeypot CSS class on the honeypot field" do
      output = @builder.spam_protect_field
      expect(output).to include("spam_protect_honeypot")
    end

    it "returns an html_safe string when not wrapped" do
      output = @builder.spam_protect_field
      # ActionView marks strings as html_safe by returning an instance of ActiveSupport::SafeBuffer
      expect(output).to be_a(ActiveSupport::SafeBuffer)
    end

    it "wraps the fields in a container when wrapper: true is passed" do
      output = @builder.spam_protect_field(wrapper: true)
      expect(output).to include('class="spam_protect"')
      expect(output).to include("spam_check")
      expect(output).to include("spam_timestamp")
    end

    it "generates a token-like value for the timestamp hidden field" do
      output = @builder.spam_protect_field
      # token is produced by the encryption layer and should look like a long base64/hex string
      # we assert presence of a value attribute on the hidden field
      expect(output).to match(/name="user\[spam_timestamp\]".*value="[^"]+"/)
    end
  end
end
