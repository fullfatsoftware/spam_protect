# spam_protect

A lightweight Ruby gem to help reduce spam in Rails applications.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'spam_protect'
```

And then execute:

    bundle install

Then add the initializer to your Rails application:

    rails generate spam_protect:install

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
  display: none;
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
    spam = validate_spam_protect_params(params[:comment])

    if spam
      # Handle spam case
    else
      @comment = Comment.new(comment_params)
      ...
    end
  end
end
```

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
