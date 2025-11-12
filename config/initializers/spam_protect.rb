# frozen_string_literal: true

# Example initializer for spam_protect
SpamProtect.configure do |config|
  # Custom field names (symbols)
  # config.honeypot_field = :my_honeypot
  # config.timestamp_field = :submitted_at

  # CSS class applied to the honeypot field
  # config.honeypot_class = "my_honeypot_class"

  # Minimum seconds required between form render and submission
  # config.min_seconds = 3
end
