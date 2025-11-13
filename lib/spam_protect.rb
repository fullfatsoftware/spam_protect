# frozen_string_literal: true

require "rails"
require "action_view"
require "active_support"
require "active_support/core_ext/numeric/time"
require "active_support/message_encryptor"
require "active_support/key_generator"

require_relative "spam_protect/errors/error"
require_relative "spam_protect/errors/encryption_unavailable"
require_relative "spam_protect/errors/no_secret_key"
require_relative "spam_protect/encryption"
require_relative "spam_protect/encryption/payload"
require_relative "spam_protect/encryption/secret_key"
require_relative "spam_protect/policies/base_policy"
require_relative "spam_protect/policies/honeypot_policy"
require_relative "spam_protect/policies/timestamp_policy"
require_relative "spam_protect/policies/encryption_policy"
require_relative "spam_protect/policies/cookie_policy"
require_relative "spam_protect/guardian"
require_relative "spam_protect/current_time"
require_relative "spam_protect/form_builder"
require_relative "spam_protect/view_helpers"
require_relative "spam_protect/version"
require_relative "spam_protect/railtie"
require_relative "spam_protect/controller_helpers"

module SpamProtect
  # Configuration object for the gem
  class Config
    attr_accessor :honeypot_field, :timestamp_field, :honeypot_class,
      :wrapper_class, :require_js, :min_seconds, :signature_secret,
      :signature_expiry

    def initialize
      @honeypot_field = :hp_phone
      @timestamp_field = :hp_ts
      @honeypot_class = "sp_hp"
      @wrapper_class = "spam_protect"
      @require_js = true
      @min_seconds = 2
      @signature_secret = nil
      @signature_expiry = 6.hours
    end
  end

  def self.config
    @config ||= Config.new
  end

  def self.configure
    yield config if block_given?
  end
end
