# frozen_string_literal: true

module SpamProtect
  class BasePolicy
    def valid?
      raise NotImplementedError, "Subclasses must implement the valid? method"
    end

    def invalid?
      !valid?
    end
  end
end
