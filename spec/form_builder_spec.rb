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
      # Create a minimal form builder instance
      @builder = ActionView::Helpers::FormBuilder.new(:user, Object.new, view, {})
    end

    it "renders honeypot and timestamp fields" do
      output = @builder.spam_protect_field
      expect(output).to include("spam_check")
      expect(output).to include("spam_timestamp")
    end
  end
end
