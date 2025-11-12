# frozen_string_literal: true

require_relative "spam_protect/version"
require_relative "spam_protect/form_builder"
require_relative "spam_protect/railtie"
require_relative "spam_protect/controller_helpers"

module SpamProtect
  class Error < StandardError; end

  # Configuration object for the gem
  class Config
    attr_accessor :honeypot_field, :timestamp_field, :honeypot_class, :min_seconds

    def initialize
      @honeypot_field = :spam_check
      @timestamp_field = :spam_timestamp
      @honeypot_class = "spam_protect_honeypot"
      @min_seconds = 2
      @signature_secret = nil
      @signature_expiry = nil
    end
  end

  def self.config
    @config ||= Config.new
  end

  def self.configure
    yield config if block_given?
  end
end
