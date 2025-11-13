# frozen_string_literal: true

module SpamProtect
  module Errors
    class EncryptionUnavailable < Error
      def message
        "ActiveSupport encryption helpers are not available. Please ensure the 'activesupport' gem is included in your project."
      end
    end
  end
end
