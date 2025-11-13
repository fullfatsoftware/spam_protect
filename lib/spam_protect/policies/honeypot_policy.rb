# frozen_string_literal: true

module SpamProtect
  module Policies
    class HoneypotPolicy < BasePolicy
      def initialize(value)
        @value = value
      end

      def valid?
        @value.nil? || @value.to_s.strip.empty?
      end
    end
  end
end
