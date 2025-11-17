# spam_protect

A lightweight Ruby gem to help reduce spam in Rails applications without relying on CAPTCHAs or third-party services. It uses a combination of honeypot fields, timestamp tokens, and optional JavaScript checks to identify and block automated spam submissions.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'spam_protect'
```

And then execute:

    bundle install

Then add the initializer to your Rails application:

    bin/rails generate spam_protect:install

## Usage

Use the form helper method `spam_protect_field` within your forms to include the necessary spam protection fields:

```ruby
<%= form_for @comment do |f| >
  <%= f.spam_protect_field %>
<% end %>
```

This generates output similar to:

```html
<input type="text" name="comment[hp_field]" class="sp_hp" autocomplete="off" tabindex="-1" />
<input type="hidden" name="comment[sp_timestamp]" value="encrypted_token_here" />
```

Visually hide the honeypot field with CSS:

```css
.sp_hp {
  display: none !important;
}
```

Include the JavaScript tag in any views where forms with spam protection are used:

```ruby
<%= spam_protect_javascript_tag %>
```
Check the results in your controller:

```ruby
class CommentsController < ApplicationController
  def create
    if validate_spam_protect_params(params[:comment])
      @comment = Comment.new(comment_params)
      ...
    else
      # handle spam case
    end
  end
end
```
## How it works

The gem uses a honeypot field and a timestamp token to detect spam submissions:

1. **Honeypot field**: A hidden field that should remain empty. If a bot fills it out, the submission is flagged as spam. Bots often fill out all fields, including hidden ones, while human users do not see them.
2. **Timestamp token**: A hidden field containing an encrypted timestamp of when the form was rendered. If the form is submitted too quickly (e.g., within a few seconds), it is likely a bot submission. This is encrypted to prevent tampering.
3. **JavaScript check**: Optionally (using `config.require_js = true`), a JavaScript snippet can be included that sets a flag when the page is fully loaded. If the form is submitted without this flag being set, it indicates that JavaScript was not executed, which is common behavior for bots.

These combined techniques help to effectively reduce spam submissions in web forms. We highly recommend also analysing the message contents (if available) for spammy keywords or patterns as an additional layer of protection.

If you want to take this a step further, consider comibing this gem with a Fail2Ban setup to block IPs that repeatedly trigger spam protections.

## Configuration

You can customize the behavior of the gem by modifying the configuration file located at `config/initializers/spam_protect.rb`. Here you can set options such as encryption keys, token expiration times, and honeypot field names.

```ruby
# Example initializer for spam_protect
SpamProtect.configure do |config|
  # Custom field names (symbols)
  config.honeypot_field = :hp_phone
  config.timestamp_field = :hp_ts

  # CSS class applied to the honeypot field
  config.honeypot_class = "sp_hp"
  config.wrapper_class = "spam_protect"

  # Require JavaScript checks
  config.require_js = true # Default is true

  # Minimum seconds required between form render and submission
  config.min_seconds = 3

  # Secret key for signing/encrypting timestamps
  config.signature_secret = SecureRandom.hex(64) # Will default to Rails secret_key_base if nil

  # Expiry duration for the signature
  config.signature_expiry = 6.hours
end

```

## Development

Clone the repository and run:

    bundle install
    bundle exec rspec
    bundle exec rubocop # for linting

### Requirements

This gem requires Ruby 3.3 or newer. The repository `.ruby-version` is set to `3.4.1` but any Ruby >= 3.3 should work.
