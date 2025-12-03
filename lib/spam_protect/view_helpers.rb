# frozen_string_literal: true

module SpamProtect
  module ViewHelpers
    # Renders an inline <script> that sets the spam_protect_token cookie.
    #
    # @param nonce [String, nil] CSP nonce to include on the script tag.
    #   Pass `content_security_policy_nonce` if using Rails CSP features.
    #
    # @example Without nonce
    #   <%= spam_protect_javascript_tag %>
    #
    # @example With CSP nonce
    #   <%= spam_protect_javascript_tag(nonce: content_security_policy_nonce) %>
    #
    def spam_protect_javascript_tag(nonce: nil)
      payload = Encryption::Payload.generate
      token = Encryption.encrypt(payload.to_h)

      js = <<~JS
        (function(){
          var token = #{token.to_json};
          document.cookie = "spam_protect_token=" + encodeURIComponent(token) + "; path=/; SameSite=Lax; Secure";
        })();
      JS

      nonce_attr = nonce ? %( nonce="#{ERB::Util.html_escape(nonce)}") : ""
      %(<script#{nonce_attr}>#{js}</script>).html_safe
    end
  end
end
