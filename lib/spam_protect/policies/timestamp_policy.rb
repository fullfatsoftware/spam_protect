# frozen_string_literal: true

module SpamProtect
  module Policies
    class TimestampPolicy < BasePolicy
      def initialize(timestamp, min_seconds)
        @timestamp = timestamp
        @min_seconds = min_seconds
      end

      def valid?
        now = CurrentTime.now
        submitted_at = Time.at(@timestamp.to_i)

        (now - submitted_at) >= @min_seconds
      end
    end
  end
end
