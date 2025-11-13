# frozen_string_literal: true

module SpamProtect
  module Policies
    class CookiePolicy < BasePolicy
      def initialize(cookie)
        @cookie = cookie
      end

      def valid?
        unless SpamProtect.config.require_js
          return true
        end

        # Decryption/validity is checked elsewhere
        @cookie.present? && @cookie.strip != ""
      end
    end
  end
end
