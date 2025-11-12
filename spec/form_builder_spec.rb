require "spec_helper"

RSpec.describe SpamProtect::FormBuilderMethods do
  let(:view) { ActionView::Base.new }

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
