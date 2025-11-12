# frozen_string_literal: true

module SpamProtect
  module Policies
    class BasePolicy
      def valid?
        raise NotImplementedError, "Subclasses must implement the valid? method"
      end

      def invalid?
        !valid?
      end
    end
  end
end
