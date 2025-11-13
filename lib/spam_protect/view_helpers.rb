# frozen_string_literal: true

module SpamProtect
  module ViewHelpers
    def spam_protect_javascript_tag
      payload = Encryption::Payload.new.generate
      token = Encryption.encrypt(payload)

      js = <<~JS
        (function(){
          var token = #{token.to_json};
          document.cookie = "spam_protect_token=" + encodeURIComponent(token) + "; path=/";
        })();
      JS

      %(<script>#{js}</script>).html_safe
    end
  end
end
