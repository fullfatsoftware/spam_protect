# frozen_string_literal: true

require "rails"
require "action_view"

module SpamProtect
  class Railtie < Rails::Railtie
    initializer "spam_protect.action_view" do
      ActiveSupport.on_load(:action_view) do
        require_relative "spam_protect/form_builder"
      end
    end

    initializer "spam_protect.action_controller" do
      ActiveSupport.on_load(:action_controller) do
        require_relative "spam_protect/controller_helpers"
        ActionController::Base.include(SpamProtect::ControllerHelpers) if defined?(ActionController::Base)
      end
    end

    # Add minimal CSS to hide the honeypot by default
    initializer "spam_protect.assets" do |app|
      app.config.assets.precompile += %w[] if app.respond_to?(:config) && app.config.respond_to?(:assets)
    end
  end
end
