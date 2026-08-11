module Jekyll
  module SanitizeContentHtmlFilter
    ALLOWED_TAGS = %w[p ul ol li img a blockquote].freeze

    # Webmention content only ever needs these elements; unwrap anything
    # else (headings, spans, etc.) rather than trying to allowlist every
    # way a source's markdown renderer might surprise us. Mirrors
    # sanitizeContentHtml in assets/interactions.js.
    def sanitize_content_html(html)
      return html if html.nil?

      html.gsub(%r{</?([a-zA-Z0-9]+)(\s[^>]*)?>}) do
        tag = Regexp.last_match(1).downcase
        ALLOWED_TAGS.include?(tag) ? Regexp.last_match(0) : ""
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::SanitizeContentHtmlFilter)
