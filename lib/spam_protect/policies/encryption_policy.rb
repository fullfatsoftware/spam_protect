# frozen_string_literal: true

module SpamProtect
  module Policies
    class EncryptionPolicy < BasePolicy
      def initialize(payload)
        @payload = payload
      end

      def valid?
        correct_shape? && between_timestamps?
      end

      protected

      def correct_shape?
        @payload.is_a?(Hash) && @payload.key?("timestamp") && @payload.key?("expires_at")
      end

      def between_timestamps?
        CurrentTime.now.between?(
          Time.at(@payload["timestamp"].to_i),
          Time.at(@payload["expires_at"].to_i)
        )
      end
    end
  end
end
