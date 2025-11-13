# frozen_string_literal: true

module SpamProtect
  module CurrentTime
    module_function

    def now
      Time.respond_to?(:current) ? Time.current : Time.now
    end
  end
end
