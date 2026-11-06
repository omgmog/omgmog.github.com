require_relative "webmention_policy"

module Jekyll
  module SanitizeContentHtmlFilter
    ALLOWED_TAGS = WebmentionPolicy::POLICY["allowed_tags"].freeze
    SAFE_URL = Regexp.new("\\A(?:#{WebmentionPolicy::POLICY["safe_url"]})", Regexp::IGNORECASE)

    # Webmention content only ever needs these elements; unwrap anything
    # else (headings, spans, etc.) rather than trying to allowlist every
    # way a source's markdown renderer might surprise us. Mirrors
    # sanitize() in assets/discussion-refresh.js.
    #
    # This is rendered from arbitrary webmention senders, so attributes are
    # dropped too (not just disallowed tags) — otherwise `onclick`/
    # `javascript:` on an allowed tag would pass straight through.
    def sanitize_content_html(html)
      return html if html.nil?

      html.gsub(%r{<(/?)([a-zA-Z0-9]+)([^>]*)>}) do
        closing = Regexp.last_match(1)
        tag     = Regexp.last_match(2).downcase
        attrs   = Regexp.last_match(3)

        next "" unless ALLOWED_TAGS.include?(tag)
        next "</#{tag}>" if closing == "/"

        case tag
        when "a"
          href = attrs[/href\s*=\s*"([^"]*)"/i, 1]
          href && href.match?(SAFE_URL) ? %(<a href="#{href}" rel="nofollow">) : "<a>"
        when "img"
          src = attrs[/src\s*=\s*"([^"]*)"/i, 1]
          alt = attrs[/alt\s*=\s*"([^"]*)"/i, 1]
          src && src.match?(SAFE_URL) ? %(<img src="#{src}" alt="#{alt}" loading="lazy">) : ""
        else
          "<#{tag}>"
        end
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::SanitizeContentHtmlFilter)
