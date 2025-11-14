# frozen_string_literal: true

require "rails/generators"

module SpamProtect
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc "Creates a SpamProtect initializer in config/initializers"

      def copy_initializer
        copy_file "spam_protect.rb", "config/initializers/spam_protect.rb"
      end
    end
  end
end
