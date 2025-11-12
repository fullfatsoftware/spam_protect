# spam_protect

A lightweight Ruby gem to help reduce spam in Rails applications.

Usage
-----

Require and call:

    require "spam_protect"
    SpamProtect.safe_text("Visit https://example.com")

Run tests:

    bundle install
    bundle exec rake

Configuration (Rails)
---------------------

Create `config/initializers/spam_protect.rb` and set options:

    SpamProtect.configure do |config|
      config.honeypot_field = :spam_check
      config.timestamp_field = :spam_timestamp
      config.honeypot_class = "spam_protect_honeypot"
      config.min_seconds = 2

        # Signature options (optional)
        # config.signature_secret = "your-secret-or-nil-to-use-rails-secret_key_base"
        # config.signature_expiry = 5.minutes.to_i # optional expiry timestamp in seconds
    end

The form builder and controller helper will use these defaults when present.

Ruby compatibility
------------------

This gem requires Ruby 3.3 or newer. The repository `.ruby-version` is set to `3.4.1` but any Ruby >= 3.3 should work.
