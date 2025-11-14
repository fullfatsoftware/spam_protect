# frozen_string_literal: true

require "rails/railtie"

module SpamProtect
  class Railtie < Rails::Railtie
    initializer "spam_protect.action_view" do
      ActiveSupport.on_load(:action_view) do
        require_relative "form_builder"
        require_relative "view_helpers"
        ActionView::Helpers::FormBuilder.include(SpamProtect::FormBuilderMethods)
        ActionView::Base.include(SpamProtect::ViewHelpers)
      end
    end

    initializer "spam_protect.action_controller" do
      ActiveSupport.on_load(:action_controller) do
        require_relative "controller_helpers"
        ActionController::Base.include(SpamProtect::ControllerHelpers) if defined?(ActionController::Base)
      end
    end
  end
end
