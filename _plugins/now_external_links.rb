# On the Now page, links to other sites open in a new tab. Done at build time, on the page's own content only
# (the nav, header and footer are left alone). Links to this blog, or relative links, stay as they are.
require "uri"

module NowExternalLinks
  OWN_HOSTS = %w[blog.omgmog.net localhost 127.0.0.1].freeze

  def self.process(html)
    html.gsub(%r{(<main\b[^>]*>)(.*?)(</main>)}m) do
      open_tag, body, close_tag = $1, $2, $3
      body = body.gsub(/<a\b([^>]*?)>/i) do
        attrs = $1
        href = attrs[/\bhref=["']([^"']+)["']/i, 1].to_s
        next "<a#{attrs}>" unless href =~ %r{\Ahttps?://}i
        host = (URI.parse(href).host rescue nil).to_s.downcase
        next "<a#{attrs}>" if host.empty? || OWN_HOSTS.include?(host)
        next "<a#{attrs}>" if attrs =~ /\btarget=/i
        "<a#{attrs} target=\"_blank\" rel=\"noopener\">"
      end
      "#{open_tag}#{body}#{close_tag}"
    end
  end
end

Jekyll::Hooks.register :pages, :post_render do |page|
  page.output = NowExternalLinks.process(page.output) if page.url == "/now/"
end
