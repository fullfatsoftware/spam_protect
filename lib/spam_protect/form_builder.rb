# frozen_string_literal: true

require "action_view/helpers/form_builder"

module SpamProtect
  module FormBuilderMethods
    def spam_protect_field(name: nil, timestamp_name: nil, wrapper: false)
      honeypot_name ||= SpamProtect.config.honeypot_field
      timestamp_name ||= SpamProtect.config.timestamp_field
      honeypot_class = SpamProtect.config.honeypot_class

      payload = Encryption::Payload.generate
      token = SpamProtect::Encryption.encrypt(payload)

      honeypot = @template.text_field_tag("#{@object_name}[#{honeypot_name}]", nil, class: honeypot_class, autocomplete: "off", tabindex: "-1")
      signature_input = @template.hidden_field_tag("#{@object_name}[#{timestamp_name}]", token)

      if wrapper
        @template.content_tag(:div, honeypot + signature_input, class: "spam_protect")
      else
        (honeypot + signature_input).html_safe
      end
    end
  end
end

# Extend ActionView::Helpers::FormBuilder if available
if defined?(ActionView) && defined?(ActionView::Helpers::FormBuilder)
  ActionView::Helpers::FormBuilder.include(SpamProtect::FormBuilderMethods)
end
